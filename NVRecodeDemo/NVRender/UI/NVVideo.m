//
//  NVVideo.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVVideo.h"
#import "VIMVideoPlayer.h"
#import "SZTVideoTexture.h"

@interface NVVideo()<VIMVideoPlayerDelegate>
{
    SZTTexture * _texture;
    BOOL _isPrepareToPlay;
}

@property(nonatomic , assign)NSURL *url;

@property(nonatomic , strong)AVPlayerItem *playerItem;

@property(nonatomic, strong)VIMVideoPlayer *avPlayer;

@end

@implementation NVVideo

- (instancetype)initAVPlayerVideoWithURL:(NSURL *)url
{
    self = [super init];
    
    if (self) {
        self.url = url;
        
        [self setupAVPlayer:url PlayerItem:nil];
    }
    
    return self;
}

- (void)setupAVPlayer:(NSURL *)url PlayerItem:(AVPlayerItem *)item
{
    AVPlayerItem *playerItem = url?[[AVPlayerItem alloc] initWithURL:url]:item;
    self.playerItem = playerItem;
    
    self.avPlayer = [[VIMVideoPlayer alloc] init];
    self.avPlayer.delegate = self;
    [self.avPlayer setPlayerItem:playerItem];
    [self.avPlayer play];
    
    [self setupVideoPlayerItem:playerItem];
}

- (void)setupVideoPlayerItem:(AVPlayerItem *)playerItem
{
    SZTVideoTexture *videoTexture = [[SZTVideoTexture alloc] init];
    _texture = [videoTexture createWithAVPlayerItem:playerItem];
}

- (void)setVideoRect:(CGRect)rect
{
    [self setShapeObject:rect];
}

- (void)updateTexture
{
    CVPixelBufferRef pixelBufferRef = [_texture updateVideoTexture:[EAGLContext currentContext]];
    
    [_texture updateTexture:self.program.uSamplerLocal];
    
    if (pixelBufferRef == nil) {
        
    }
}

#pragma mark video player属性
- (float)duration
{
    if (self.avPlayer) {
        return CMTimeGetSeconds(self.playerItem.duration);
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        return self.ijkPlayer.duration - 1.0;
    }
#endif
    
    return 0;
}

- (float)currentTime
{
    if (self.avPlayer) {
        return CMTimeGetSeconds([self.playerItem currentTime]);
    }
    
    return 0;
}

- (void)seekToTime:(float)time
{
    if (self.avPlayer) {
        [self.avPlayer seekToTime:time];
    }
}

- (void)pause
{
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

- (void)stop
{
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

- (void)play
{
    if (self.avPlayer) {
        [self.avPlayer play];
    }
}

- (void)setPrepareToPlay:(BOOL)isPlay
{
    _isPrepareToPlay = isPlay;
}

- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer
{
    [self setPrepareToPlay:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoIsReadyToPlay:)]) {
        [self.delegate videoIsReadyToPlay:self];
    }
}

- (void)destory
{
    [super destory];
    
    if (_texture) [_texture destory];
    
    if (self.avPlayer) {
        [self destoryAvPlayer];
    }
}

- (void)destoryAvPlayer
{
    self.avPlayer = nil;
}

- (void)dealloc
{
    [self destory];
}
@end
