//
//  NVCamera.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import "NVCamera.h"
#import "LocalCameraUtil.h"

@interface NVCamera()

@property(nonatomic, strong)LocalCameraUtil *camera;

@end

@implementation NVCamera

- (instancetype)initWithDevicePosition:(NVCameraMode)camera
{
    self = [super init];
    
    if (self) {
        [self initLocalCamera:camera];
    }
    
    return self;
}

- (void)initLocalCamera:(NVCameraMode)camera
{
    self.camera = [[LocalCameraUtil alloc] initWithDevicePosition:camera];
    [self.camera startRunning];
    
    self.videoSize = CGSizeMake(1080.0, 1920.0);
}

- (void)startRunning
{
    [self.camera startRunning];
}

- (void)stopRunning
{
    [self.camera stopRunning];
}

- (void)updateTexture
{
    [super updateTexture];

    [self.camera uptateTexture:self.program.uSamplerLocal];
}

- (void)destory
{
    [super destory];
    
    if (self.camera) {
        [self stopRunning];
        [self.camera destory];
        self.camera = nil;
    }
}

- (void)dealloc
{
    [self destory];
}

@end
