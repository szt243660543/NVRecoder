//
//  GLUtils.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "GLUtils.h"
#import <OpenGLES/ES2/glext.h>

@implementation GLUtils

+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment isFilePath:(BOOL)isfile
{
    GLuint vertShader, fragShader;
    
    // Create and compile vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER content:shaderVertex isFilePath:isfile]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER content:shaderFragment isFilePath:isfile]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // 连接vertex和fragment shader成一个完整的program
    GLuint _glProgram = glCreateProgram();
    glAttachShader(_glProgram, vertShader);
    glAttachShader(_glProgram, fragShader);
    
    // Link program.
    if (![self linkProgram:_glProgram]) {
        NSLog(@"Failed to link program: %d", _glProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_glProgram) {
            glDeleteProgram(_glProgram);
            _glProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_glProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_glProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return _glProgram;
}

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type content:(NSString *)content  isFilePath:(BOOL)isfile
{
    GLint status;
    const GLchar *source;
    
    if (isfile) {
        source = (GLchar *)[[NSString stringWithContentsOfFile:content encoding:NSUTF8StringEncoding error:nil] UTF8String];
    }else{
        source = (GLchar *)[content UTF8String];
    }
    
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

+ (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

+ (GLuint)setupTextureWithFileName:(NSString *)fileName
{
    UIImage *image = [UIImage imageNamed:fileName];
    
    if (!image) {
        NSLog(@"Fail to load image from path:%@",fileName);
        return -1;
    }
    
    return [self setupTextureWithImage:image];
}

+ (GLuint)setupTextureWithImage:(UIImage *)image
{
    CGImageRef cgImageRef = [image CGImage];
    if (!cgImageRef) {
        NSLog(@"Fail to load image!");
        return -1;
    }
    
    GLuint width = [self NextPot:(GLuint)CGImageGetWidth(cgImageRef)];
    GLuint height = [self NextPot:(GLuint)CGImageGetHeight(cgImageRef)];
    CGRect rect = CGRectMake(0, 0, width, height);
    
    GLubyte *imageData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGColorSpaceRelease(colorSpace);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, rect, cgImageRef);
    CGContextRelease(context);
    
    GLuint texture_id;
    glGenTextures(1, &texture_id);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    glGetError();
    glBindTexture(GL_TEXTURE_2D, 0);
    
    free(imageData);
    
    return texture_id;
}

//+ (void)setGLTextureMinFilter:(SZTTextureFilter)textureFilter
//{
//    switch (textureFilter) {
//        case SZT_LINEAR:
//
//            break;
//        case SZT_NEAREST:
//
//            break;
//        case SZT_LINEAR_MIPMAP_LINEAR:
//            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
//            break;
//        case SZT_LINEAR_MIPMAP_NEAREST:
//            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
//            break;
//        case SZT_NEAREST_MIPMAP_LINEAR:
//            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_LINEAR);
//            break;
//        case SZT_NEAREST_MIPMAP_NEAREST:
//            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
//            break;
//        default:
//            break;
//    }
//}

+ (int)NextPot:(int)n
{
    n--;
    n |= n >> 1; n |= n >> 2;
    n |= n >> 4; n |= n >> 8;
    n |= n >> 16;
    n++;
    
    return n;
}

@end
