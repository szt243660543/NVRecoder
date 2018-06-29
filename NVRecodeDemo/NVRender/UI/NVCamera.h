//
//  NVCamera.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import "NVRenderObject.h"

typedef NS_ENUM(NSInteger, NVCameraMode) {
    CAMERA_FRONT,           // 前置摄像头
    CAMERA_BACK,            // 后置摄像头
};

@interface NVCamera : NVRenderObject

- (instancetype)initWithDevicePosition:(NVCameraMode)camera;

/**
 * 全屏 rect {0,0,1,1}
 * 宽高最大为1，取0~1之间
 */
- (void)setVideoRect:(CGRect)rect;

- (void)destory;

@end
