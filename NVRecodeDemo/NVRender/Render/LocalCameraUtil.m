//
//  LocalCameraUtil.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "LocalCameraUtil.h"
#import "DeviceManager.h"
#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/ES2/glext.h>
#import "SZTTexture.h"
#import "CIFilter+LUT.h"

@interface LocalCameraUtil() <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t mProcessQueue;
    dispatch_queue_t videoDataHandleQueue;
    CVOpenGLESTextureCacheRef _videoTextureCache;
    
    NVCameraMode cameraType;
    
    EAGLContext *_glContext;
    BOOL isLock;
}

@property (nonatomic , strong) AVCaptureSession *mCaptureSession;
@property (nonatomic , strong) AVCaptureDeviceInput *mCaptureDeviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;
@property (nonatomic , strong) AVCaptureStillImageOutput *mStillImageOutput;
@property (nonatomic , strong) AVCaptureConnection *mVideoConnection;
@property (nonatomic , strong) SZTTexture *texture;

@end

@implementation LocalCameraUtil

- (instancetype)initWithDevicePosition:(NVCameraMode)camera
{
    self = [super init];
    
    if (self) {
        isLock = true;
        cameraType = camera;
        
        [self setupCaptureSession];
        
        [self setupVideoInput];
        
        [self setupVideoDataOutput];
        
        [self setupCaptureStillImageOutput];
        
        [self textureCache];
        
        self.texture = [[SZTTexture alloc] init];
    }
    
    return self;
}

- (BOOL)setupCaptureSession
{
    if (!self.mCaptureSession) {
        self.mCaptureSession = [[AVCaptureSession alloc] init];
        
        // default capture
        [self setCaptureSessionPreset:SessionPreset1280x720];
        
        if (!self.mCaptureSession){
            return NO;
        }
    }
    
    return YES;
}

- (void)setCaptureSessionPreset:(SZTSessionPreset)sessionPreset
{
    switch (sessionPreset) {
        case SessionPreset640x480:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset640x480;
            break;
        case SessionPreset1280x720:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
            break;
        case SessionPreset1920x1080:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
            break;
        case SessionPreset3840x2160:
            self.mCaptureSession.sessionPreset = AVCaptureSessionPreset3840x2160;
            break;
        default:
            break;
    }
}

- (BOOL)setupVideoInput
{
    BOOL success;
    AVCaptureDevice *videoDevice = cameraType == CAMERA_FRONT?[DeviceManager frontCamera]:[DeviceManager backCamera];
    
    AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    if ((success = [self.mCaptureSession canAddInput:videoIn]))
    {
        [self.mCaptureSession addInput:videoIn];
    }
    
    videoDataHandleQueue = dispatch_queue_create("video data handle", DISPATCH_QUEUE_SERIAL);
    if (!videoDataHandleQueue) {
        return NO;
    }
    
    return success;
}

- (BOOL)setupVideoDataOutput
{
    BOOL success = NO;
    if (self.mCaptureSession){
        
        self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:YES];
        
//      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        mProcessQueue = dispatch_get_main_queue();
//        mProcessQueue = dispatch_queue_create("mProcessQueue.queue", DISPATCH_QUEUE_SERIAL);
        [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
        
        if ((success = [self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput])) {
            [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
        }
        
        AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    return success;
}

- (BOOL)setupCaptureStillImageOutput
{
    BOOL success = NO;
    
    //建立 AVCaptureStillImageOutput
    self.mStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    [self.mStillImageOutput setOutputSettings:outputSettings];
    
    if ((success = [self.mCaptureSession canAddOutput:self.mStillImageOutput])) {
        [self.mCaptureSession addOutput:self.mStillImageOutput];
    }
    
    self.mVideoConnection = [self.mStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.mVideoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
    return success;
}

- (void)startRunning
{
    [self.mCaptureSession startRunning];
}

- (void)stopRunning
{
    [self.mCaptureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 滤镜 CVPixelBufferRef->CIImage->CIFilter->CIImage->CVPixelBufferRef
    CVImageBufferRef pixelBuffer = NULL;
    if (self.filter) {
        pixelBuffer = [self.filter coreImageHandle:CMSampleBufferGetImageBuffer(sampleBuffer)];
    }else{
        pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    }
    
    if (_glContext) [EAGLContext setCurrentContext:_glContext];
    
    GLuint textureID = [self getTextureid:pixelBuffer];
    [self.texture setTextureID:textureID];
    isLock = false;
}

- (GLuint)getTextureid:(CVPixelBufferRef)pixelBuffer
{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    CVReturn err;
    
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    if (!_videoTextureCache)
    {
        NSLog(@"No video texture cache");
        return -1;
    }
    
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
    
    CVOpenGLESTextureRef texture = NULL;
    
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _videoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RGBA,
                                                       (int)width,
                                                       (int)height,
                                                       GL_BGRA,
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &texture);
    
    if (err)
    {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    
    GLuint textureid = CVOpenGLESTextureGetName(texture);
    glBindTexture(GL_TEXTURE_2D, textureid);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    CFRelease(texture);
    
    return textureid;
}

- (CVOpenGLESTextureCacheRef)textureCache
{
    if (_videoTextureCache == NULL){
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [EAGLContext currentContext], NULL, &_videoTextureCache);
        if (err) NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate");
    }
    
    return _videoTextureCache;
}

- (BOOL)uptateTexture:(GLuint)uSamplerLocal
{
//    if (isLock) return false;
    
    if (!_glContext) _glContext = [EAGLContext currentContext];
    
    [self.texture updateTexture:uSamplerLocal];
    isLock = true;
    
    return true;
}

- (void)destory
{
    if (self.texture) {
        [self.texture destory];
    }
}

- (void)dealloc
{
    [self destory];
}

@end
