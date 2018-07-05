//
//  NVGLCamera.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Singleton.h"

@interface NVGLCamera : NSObject
SingletonH(NVGLCamera)

- (void)setupMatrix;

@property(nonatomic, assign)GLKMatrix4 mModelViewProjectionMatrix;

@property(nonatomic, assign)GLKMatrix4 mModelMatrix;
@property(nonatomic, assign)GLKMatrix4 mViewMatrix;
@property(nonatomic, assign)GLKMatrix4 mProjectionMatrix;
@property(nonatomic, assign)GLKMatrix4 mModelViewMatrix;

// view宽高
@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;
// 像素宽高
@property(nonatomic, assign)float widthPx;
@property(nonatomic, assign)float HeightPx;

@end
