//
//  NVRecord.h
//
//  Created by Mac on 2018/6/23.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@protocol NVRecordDelegate <NSObject>

- (void)endMerge;

@end

@interface NVRecord : NSObject

/**
 保存录屏文件名,如果名字一样则会覆盖, (fileName不需要带后缀，程序自动生成)
 默认保存在Document目录下Recode文件夹下，自动保存文件：
 {
        ../Recode/fileName.mp4            // 视频文件
        ../Recode/fileName.caf            // 音频文件
        ../Recode/fileName_output.mp4     // 音视频合成文件文件
 }
 */
- (instancetype)initWithRecodeName:(NSString *)fileName;

@property (nonatomic, weak) id<NVRecordDelegate> delegate;

/**
 开始录制
 */
- (void)startRecording;

/**
 结束录制
 */
- (void)endRecording;

@property(nonatomic, assign)CVPixelBufferRef renderTarget;
//CVPixelBufferRef          renderTarget;
/**
 多个视频合成
 */
+ (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath;

@end
