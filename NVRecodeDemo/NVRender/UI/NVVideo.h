//
//  NVVideo.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVRenderObject.h"
#import <AVFoundation/AVFoundation.h>

@class NVVideo;

@protocol NVVideoDelegate <NSObject>
@optional
- (void)errorToLoadVideo:(NVVideo *)video;
- (void)videoIsReadyToPlay:(NVVideo *)video;
- (void)videoDidPlayBcakFinished:(NVVideo *)video;

@end

@interface NVVideo : NVRenderObject

/**
 * 初始化－avplayer 视频资源/模式
 * @param url 视频地址
 */
- (instancetype)initAVPlayerVideoWithURL:(NSURL *)url;

/**
 * 全屏 rect {0,0,1,1}
 * 宽高最大为1，取0~1之间
 */
- (void)setVideoRect:(CGRect)rect;

#pragma mark video player属性
@property(nonatomic, assign)float duration;

@property(nonatomic, assign)float currentTime;

- (void)seekToTime:(float)time;

- (void)pause;

- (void)stop;

- (void)play;

@property(nonatomic , weak)id <NVVideoDelegate> delegate;

@end
