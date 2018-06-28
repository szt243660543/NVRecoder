//
//  NVFbo.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVFbo.h"
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "Shader_Normal.h"
#import "NVProgram.h"
#import "NVDrawShape.h"

@interface NVFbo()
{
    int         _fbo_width;
    int         _fbo_height;
    
    GLuint      _depthBuffer;
}

@property(nonatomic, assign)CVOpenGLESTextureCacheRef textureCache;

@property(nonatomic, assign)GLuint fboHandle;

@property(nonatomic, assign)GLuint fboTex;

@property(nonatomic, assign)GLint defaultFBO;

@property(nonatomic, strong)NVProgram *program;

@property(nonatomic, strong)NVDrawShape *shape;

@end

@implementation NVFbo

- (instancetype)initWithFboWidth:(int)width height:(int)height
{
    self = [super init];
    
    if (self) {
        _fbo_width = width;
        _fbo_height = height;
        
        [self createTexrureCache];
        
        [self setupFbo];
        
        [self setShapeObject];
        
        [self setFboProgram];
    }
    
    return self;
}

- (void)createTexrureCache
{
    if (!_textureCache) {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [EAGLContext currentContext], NULL, &_textureCache);
        if (err != noErr) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
            return;
        }
    }
}

- (void)setupFbo
{
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFBO);
    
    glGenFramebuffers(1, &_fboHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _fbo_width, _fbo_height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    
    // FBO status check
    GLenum status;
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete");
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            /* programming error; will fail on all hardware */
            NSLog(@"Framebuffer Error");
            break;
    }
    
    [self bindingFbotextureToCache];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
}

- (void)bindingFbotextureToCache
{
    if (!_textureCache) {
        return;
    }
    
    CFDictionaryRef empty; // empty value for attr value.
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault, // our empty IOSurface properties dictionary
                               NULL,
                               NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                      1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs,
                         kCVPixelBufferIOSurfacePropertiesKey,
                         empty);
    
    CVPixelBufferCreate(kCFAllocatorDefault,
                        _fbo_width,
                        _fbo_height,
                        kCVPixelFormatType_32BGRA,
                        attrs,
                        &_renderTarget);
    
    CVOpenGLESTextureRef renderTexture;
    CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault,
                                                  _textureCache,
                                                  _renderTarget,
                                                  NULL, // texture attributes
                                                  GL_TEXTURE_2D,
                                                  GL_RGBA, // opengl format
                                                  _fbo_width,
                                                  _fbo_height,
                                                  GL_BGRA, // native iOS format
                                                  GL_UNSIGNED_BYTE,
                                                  0,
                                                  &renderTexture);
    CFRelease(attrs);
    CFRelease(empty);
    glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture), 0);
    _fboTex = CVOpenGLESTextureGetName(renderTexture);
}

- (void)setShapeObject
{
    self.shape= [[NVDrawShape alloc] init];
    [self.shape setupDefaultData];
}

- (void)setFboProgram
{
    _program = [[NVProgram alloc] init];
    
    [_program loadShaders:NormalVertexShaderString FragShader:NormalFragmentShaderString isFilePath:NO];
}

- (void)bind
{
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, _fbo_width, _fbo_height);
}

- (void)unbind
{
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)updateTexture
{
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, _fboTex);
    
    glUniform1i(_program.uSamplerLocal, 0);
}

- (void)render
{
    glViewport(0, 0, _fbo_width, _fbo_height);
    glClearColor(0.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_program useProgram];
    
    [self updateTexture];
    
    glUniformMatrix4fv(self.program.mvp, 1, 0, GLKMatrix4Identity.m);
    
    [self.shape drawElementsFBO:_program];
}

- (void)dealloc
{
    if (_program) {
        [_program destory];
        _program = nil;
    }
    
    if (self.shape) {
        [self.shape destroy];
        self.shape = nil;
    }
    
}

@end
