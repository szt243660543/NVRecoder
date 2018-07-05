//
//  ViewController.m
//
//  Created by Mac on 2018/6/23.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#import "NVViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/glext.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NVFbo.h"
#import "NVVideo.h"
#import "GLUtils.h"
#import "Shader_Normal.h"
#import "NVGLCamera.h"

@interface NVViewController()
{
    EAGLContext *_glContext;
    BOOL        _isLock;
}

@property(nonatomic, strong)NVFbo *fbo;

@property(nonatomic, strong)NSMutableArray *objectArr;

@end

@implementation NVViewController

- (NSMutableArray *)objectArr
{
    if (!_objectArr) {
        _objectArr = [NSMutableArray array];
    }
    
    return _objectArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupContext];

    [self setupGL];
    
    [[NVGLCamera sharedNVGLCamera] setupMatrix];
}

- (void)setupContext
{
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_glContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = _glContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == _glContext) {
        [EAGLContext setCurrentContext:nil];
    }
	_glContext = nil;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:_glContext];
    
    int fbo_width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale;
    int fbo_height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale;
    
    self.fbo = [[NVFbo alloc] initWithFboWidth:fbo_width height:fbo_height];
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:_glContext];
    
    if (self.fbo) {
        self.fbo = nil;
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [super glkView:view drawInRect:rect];
    
    glEnable(GL_DEPTH_TEST);
    
    // render FBO tex
    [self renderFBO];

    [((GLKView *) self.view) bindDrawable];

    [self.fbo render];
    
    glDisable(GL_DEPTH_TEST);
}

- (void)renderFBO
{
    if (_isLock) return;
    
    [self.fbo bind];
    
    for (NVRenderObject *object in self.objectArr) {
        [object render];
    }
    
    [self.fbo unbind];
}

- (void)addRenderTarget:(NVRenderObject *)object
{
    _isLock = true;
    [self.objectArr addObject:object];
    _isLock = false;
}

- (void)removeRenderTarget:(NVRenderObject *)object
{
    _isLock = true;
    [object destory];
    [self.objectArr removeObject:object];
    _isLock = false;
}

- (CVPixelBufferRef)getSurfaceBuffer
{
    return self.fbo.renderTarget;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

@end
