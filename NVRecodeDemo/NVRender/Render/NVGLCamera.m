//
//  NVGLCamera.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import "NVGLCamera.h"

@implementation NVGLCamera
SingletonM(NVGLCamera)

- (void)setupMatrix
{
    self.width = [UIScreen mainScreen].bounds.size.width;
    self.height = [UIScreen mainScreen].bounds.size.height;
    self.widthPx = self.width * [UIScreen mainScreen].nativeScale;
    self.HeightPx = self.height * [UIScreen mainScreen].nativeScale;
    
    self.mModelMatrix = GLKMatrix4Identity;
    [self setupCamera];
    float aspect = fabsf(self.width/self.height);
    self.mProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(83.0f), aspect, 0.1f, 1000.0f);
    
    self.mModelViewMatrix = GLKMatrix4Multiply(self.mViewMatrix, self.mModelMatrix);
    self.mModelViewProjectionMatrix = GLKMatrix4Multiply(self.mProjectionMatrix, self.mModelViewMatrix);
}

- (void)setupCamera
{
    float eyeX = 0.0f;
    float eyeY = 0.0f;
    float eyeZ = 0.0f;
    
    float lookX = 0.0f;
    float lookY = 0.0f;
    float lookZ = -1.0f;
    
    float upX = 0.0f;
    float upY = 1.0f;
    float upZ = 0.0f;
    
    self.mViewMatrix = GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
}

@end
