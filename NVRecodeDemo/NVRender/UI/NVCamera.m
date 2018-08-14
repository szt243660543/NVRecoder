//
//  NVCamera.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import "NVCamera.h"
#import "LocalCameraUtil.h"

@interface NVCamera()
{
    
}

@property(nonatomic, strong)LocalCameraUtil *camera;

@end

@implementation NVCamera

- (instancetype)initWithDevicePosition:(NVCameraMode)camera
{
    self = [super init];
    
    if (self) {
        _isFilp = camera == CAMERA_FRONT?YES:NO;
        [self initLocalCamera:camera];
    }
    
    return self;
}

- (void)initLocalCamera:(NVCameraMode)camera
{
    self.camera = [[LocalCameraUtil alloc] initWithDevicePosition:camera];
    [self.camera startRunning];
    
    self.videoSize = CGSizeMake(720.0, 1280.0);
}

//- (void)setupFilter
//{
//    self.filter = [[NVFilter alloc] init];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Filter.bundle/Filter_25/fresh_5/fresh_5.png" ofType:nil];
//    self.filter.coreImageFilter = [CIFilter filterWithLUT:path dimension:64];
//}

- (void)addCIFilter:(NVCIFilter *)filter
{
    if (self.camera.filter) self.camera.filter = nil;

    self.camera.filter = filter;
}

- (void)startRunning
{
    [self.camera startRunning];
}

- (void)stopRunning
{
    [self.camera stopRunning];
}

- (BOOL)updateTexture
{
    BOOL success = [self.camera uptateTexture:self.program.uSamplerLocal];
    
    return success;
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
