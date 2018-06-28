//
//  NVRecord.m
//
//  Created by Mac on 2018/6/23.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#import "NVRecord.h"

@interface NVRecord()<AVAudioRecorderDelegate>
{
    BOOL        _enterHome;
    NSString    *_fileName;
}

@property (nonatomic, strong) AVAssetWriter * writer; //负责写的类
@property (nonatomic, strong) AVAssetWriterInput * videoInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
@property (nonatomic, strong) dispatch_queue_t  videoQueue;    //写入的队列
@property (nonatomic, strong) dispatch_queue_t  audioQueue;    //写入的队列

@property (nonatomic, copy)   NSString * videoPath;   //路径
@property (nonatomic, copy)   NSString * audioPath;   //路径
@property (nonatomic, assign) CGSize outputSize;      //输出的分辨率

@property (nonatomic, assign) BOOL isFirstWriter;  //是否是第一次写入

@property (nonatomic, assign) CMTime initialTime;
@property (nonatomic, assign) CMTime currentTime;
@property (nonatomic, assign) CMTime enterHomeTime;

@property (nonatomic, strong) CADisplayLink * displayLink;

@property (nonatomic, strong) AVAudioSession * recordingSession;
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;


@end

@implementation NVRecord

- (instancetype)initWithRecodeName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        [self initData];
    }
    return self;
}


- (void)initData {
    // 创建队列
    self.videoQueue = dispatch_queue_create("video.queue", NULL);
    self.audioQueue = dispatch_queue_create("audio.queue", NULL);
    
    // 设置输出分辨率
    self.outputSize = CGSizeMake(SCREEN_WIDTH * [UIScreen mainScreen].nativeScale, SCREEN_HEIGHT * [UIScreen mainScreen].nativeScale);
    
    // 是否是第一次写入
    self.isFirstWriter = YES;
    
    // 清理旧文件
    [self clearPath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
}

- (void)clearPath
{
    NSString *filePath = [self createFilePathWithName:@"Recode"];
    self.videoPath = [NSString stringWithFormat:@"%@/%@.mp4",filePath, _fileName];
    self.audioPath = [NSString stringWithFormat:@"%@/%@.caf",filePath, _fileName];
    NSString * output = [NSString stringWithFormat:@"%@/%@_output.mp4",filePath, _fileName];
    
    //如果有就先清除
    [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.audioPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:output error:nil];
}

- (NSString *)createFilePathWithName:(NSString *)filePathName
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,filePathName];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        return createPath;
    } else {
        return createPath;
    }
}

- (void)startRecording {
    //设置存储路径
    self.writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeQuickTimeMovie error:nil];
    
    [self initVideoInPut];
    
    [self initPixelBufferAdaptor];
    
    // 开始写入
    [self.writer startWriting];
    
    self.initialTime = kCMTimeInvalid;
    self.initialTime = [self getCurrentCMTime];
    
    //设置写入时间
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    
    //启动定时器
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink)];
    self.displayLink.preferredFramesPerSecond = 60;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

//先录制视频 录取到第一帧后开始录制音频
- (void)updateDisplayLink
{
    if (_enterHome) return;
    
    dispatch_async(self.videoQueue, ^{
        CMTime appendTime = [self getAppendTime];
        
        if (!CMTIME_IS_VALID(appendTime)) {
            return;
        }
        
        @try {
            if (kCVReturnSuccess == CVPixelBufferLockBaseAddress(self.renderTarget, kCVPixelBufferLock_ReadOnly))
            {
                BOOL success = [self.pixelBufferAdaptor appendPixelBuffer:self.renderTarget withPresentationTime:appendTime];
                NSLog(@"wrote at %@ : %@", CMTimeCopyDescription(NULL, appendTime), success ? @"YES" : @"NO");
                CVPixelBufferUnlockBaseAddress(self.renderTarget, kCVPixelBufferLock_ReadOnly);
            }
            
            if (self.isFirstWriter == YES) {
                
                self.isFirstWriter = NO;
                
                [self recorderAudio];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"fail recode~");
        } @finally {
        }
    });
}

//录制音频
- (void)recorderAudio {
    // 音频
    dispatch_async(self.audioQueue, ^{
        self.recordingSession = [AVAudioSession sharedInstance];
        
        [self.recordingSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        
        [self.recordingSession setActive:YES error:NULL];
        
        if (![self.audioRecorder isRecording]) {
            [self.audioRecorder record];
        }
    });
}

//结束录制
- (void)endRecording {
    
    [self.audioRecorder stop];
    
    if (self.displayLink) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    self.isFirstWriter = YES;
    
    [self.videoInput markAsFinished];
    
    [self.writer finishWritingWithCompletionHandler:^{
        //合并
        [self merge];
    }];
    
}

- (void)merge {
    
    AVMutableComposition * mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack * mutableCompositionVideoTrack = nil;
    AVMutableCompositionTrack * mutableCompositionAudioTrack = nil;
    AVMutableVideoCompositionInstruction * totalVideoCompositionInstruction = [[AVMutableVideoCompositionInstruction alloc] init];
    
    AVURLAsset * aVideoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.videoPath]];
    AVURLAsset * aAudioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.audioPath]];
    
    mutableCompositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    mutableCompositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    dispatch_semaphore_t videoTrackSynLoadSemaphore;
    videoTrackSynLoadSemaphore = dispatch_semaphore_create(0);
    dispatch_time_t maxVideoLoadTrackTimeConsume = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    [aVideoAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    [aAudioAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    NSArray<AVAssetTrack *> * videoTrackers = [aVideoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (0 >= videoTrackers.count) {
        NSLog(@"VideoTracker failed----");
        return;
    }
    NSArray<AVAssetTrack *> * audioTrackers = [aAudioAsset tracksWithMediaType:AVMediaTypeAudio];
    if (0 >= audioTrackers.count) {
        NSLog(@"AudioTracker failed");
        return;
    }
    
    AVAssetTrack * aVideoAssetTrack = videoTrackers[0];
    AVAssetTrack * aAudioAssetTrack = audioTrackers[0];
    
    [mutableCompositionVideoTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aVideoAssetTrack atTime:kCMTimeZero error:nil];
    [mutableCompositionAudioTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aAudioAssetTrack atTime:kCMTimeZero error:nil];
    
    totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration);
    
    AVMutableVideoComposition * mutableVideoComposition = [[AVMutableVideoComposition alloc]init];
    
    mutableVideoComposition.frameDuration = CMTimeMake(1, 60);
    mutableVideoComposition.renderSize = self.outputSize;
    
    NSString *filePath = [self createFilePathWithName:@"Recode"];
    NSString *output = [NSString stringWithFormat:@"%@/%@_output.mp4",filePath, _fileName];
    NSURL *savePathUrl = [NSURL fileURLWithPath:output];
    
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputFileType = AVFileTypeAppleM4V;
    assetExport.outputURL = savePathUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    self.videoPath = [savePathUrl path];
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        UISaveVideoAtPathToSavedPhotosAlbum(self.videoPath, nil, nil, nil);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(endMerge)]) {
            [self.delegate endMerge];
        }
    }];
    
}

#pragma mark ======================================= 和时间有关的方法 =======================================

- (CMTime)getCurrentCMTime {
    return CMTimeMakeWithSeconds(CACurrentMediaTime(), 1000);
}

- (CMTime)getAppendTime {
    if (CMTIME_IS_VALID(self.enterHomeTime)) {
        CMTime temp = CMTimeSubtract([self getCurrentCMTime], self.initialTime);
        self.currentTime = CMTimeAdd(temp, self.enterHomeTime);
    }else{
        self.currentTime = CMTimeSubtract([self getCurrentCMTime], self.initialTime);
    }
    
    return self.currentTime;
}

#pragma mark ======================================= 代理方法 =======================================

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"音频错误");
    NSLog(@"error == %@",error);
    
}

#pragma mark ============================ 初始化方法 ============================

- (void)initVideoInPut {
    
    self.videoInput = [[AVAssetWriterInput alloc]
                       initWithMediaType:AVMediaTypeVideo
                       outputSettings   :@{AVVideoCodecKey:AVVideoCodecH264,
                                           AVVideoWidthKey: @(self.outputSize.width),
                                           AVVideoHeightKey: @(self.outputSize.height)}];
    
//    self.videoInput.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    if ([self.writer canAddInput:self.videoInput]) {
        [self.writer addInput:self.videoInput];
    }
}

- (void)initPixelBufferAdaptor {
    
    self.pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.videoInput sourcePixelBufferAttributes:
                               @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA),
                                 (id)kCVPixelBufferWidthKey:@(self.outputSize.width),
                                 (id)kCVPixelBufferHeightKey:@(self.outputSize.height)}];
}

/* 初始化录音器 */
- (AVAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        
        //创建URL
        NSString *filePath = self.audioPath;
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        //设置录音格式
        [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音采样率，8000/44100/96000
        [settings setObject:@(44100) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [settings setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [settings setObject:@(16) forKey:AVLinearPCMBitDepthKey];
        //采样质量
        [settings setObject:@(AVAudioQualityMedium) forKey:AVEncoderAudioQualityKey];
        [settings setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        //创建录音器
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:settings
                                                        error:&error];
        if (error) {
            NSLog(@"初始化录音器失败");
            NSLog(@"error == %@",error);
        }
        
        _audioRecorder.delegate = self;//设置代理
        [_audioRecorder prepareToRecord];//为录音准备缓冲区
        
    }
    return _audioRecorder;
}


- (void)applicationWillResignActive:(NSNotification *)notification
{
    printf("触发home按下\n");
    _enterHome = true;
    self.enterHomeTime = kCMTimeInvalid;
    self.enterHomeTime = self.currentTime;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    printf("重新进来后响应\n");
    _enterHome = false;
    self.initialTime = [self getCurrentCMTime];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ============================ 类方法 ============================
+ (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath
{
    if (videosPathArray.count == 0) {
        return;
    }
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime totalDuration = kCMTimeZero;

    for (NSString *video in videosPathArray) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:video]];
        NSError *erroraudio = nil;
        //获取AVAsset中的音频 或者视频
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        //向通道内加入音频或者视频
        BOOL ba = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                      ofTrack:assetAudioTrack
                                       atTime:totalDuration
                                        error:&erroraudio];
        
        NSLog(@"erroraudio:%@%d",erroraudio, ba);
        NSError *errorVideo = nil;
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        BOOL bl = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                      ofTrack:assetVideoTrack
                                       atTime:totalDuration
                                        error:&errorVideo];
        
        NSLog(@"errorVideo:%@%d",errorVideo, bl);
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:outpath];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeAppleM4V;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"exporter%@",exporter.error);
    }];}

@end
