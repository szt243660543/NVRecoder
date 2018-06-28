//
//  NVProgram.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/25.
//

#import "NVProgram.h"
#import <OpenGLES/ES2/glext.h>
#import "GLUtils.h"

@implementation NVProgram

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        attributes = [[NSMutableArray alloc] init];
        uniforms = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark -  OpenGL ES 2 shader compilation

/**
 * 加载纹理
 * @param vertShader 顶点着色器
 * @param fragShader 片段着色器
 * @param isFilePath 是否是文本路径
 */
- (void)loadShaders:(NSString *)vertShader FragShader:(NSString *)fragShader isFilePath:(BOOL)isfile
{
    self.program = [GLUtils compileShaders:vertShader shaderFragment:fragShader isFilePath:isfile];
    
    self.vertexHandle = glGetAttribLocation(self.program, "position");
    glEnableVertexAttribArray(self.vertexHandle);
    
    self.texCoordHandle = glGetAttribLocation(self.program, "aTexCoord");
    glEnableVertexAttribArray(self.texCoordHandle);
    
    self.uSamplerLocal = glGetUniformLocation(self.program, "uSampler");
    
    self.mvp = glGetUniformLocation(self.program, "modelViewProjectionMatrix");
}

- (void)addAttribute:(NSString *)attributeName
{
    if (![attributes containsObject:attributeName])
    {
        [attributes addObject:attributeName];
        glBindAttribLocation(self.program, (GLuint)[attributes indexOfObject:attributeName], [attributeName UTF8String]);
    }
}

- (GLuint)uniformIndex:(NSString *)uniformName
{
    return glGetUniformLocation(self.program, [uniformName UTF8String]);
}

- (GLuint)attributeIndex:(NSString *)attributeName
{
    return (GLuint)[attributes indexOfObject:attributeName];
}

- (void)useProgram
{
    glUseProgram(self.program);
}

- (void)destory
{
    if (self.program) {
        glDeleteProgram(self.program);
        self.program = 0;
    }
}

-(void)dealloc
{
    [self destory];
}

@end
