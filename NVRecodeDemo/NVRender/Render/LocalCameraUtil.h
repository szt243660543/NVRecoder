//
//  LocalCameraUtil.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVCamera.h"
#import "NVCIFilter.h"

typedef NS_ENUM(NSInteger, SZTSessionPreset) {
    SessionPreset640x480,
    SessionPreset1280x720,
    SessionPreset1920x1080,
    SessionPreset3840x2160,
};

@interface LocalCameraUtil : NSObject

- (instancetype)initWithDevicePosition:(NVCameraMode)camera;

- (void)setCaptureSessionPreset:(SZTSessionPreset)sessionPreset;

- (void)startRunning;

- (void)stopRunning;

- (BOOL)uptateTexture:(GLuint)uSamplerLocal;

- (void)destory;

@property(nonatomic , strong) NVCIFilter *filter;

@end
