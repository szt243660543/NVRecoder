//
//  SZTTexture.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTTexture.h"
#import "GLUtils.h"

@implementation SZTTexture

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _textureID = -2;
    }
    
    return self;
}

- (SZTTexture *)setupTextureWithImage:(UIImage *)image
{
    return self;
}

- (SZTTexture *)createTextureWithPath:(NSString *)path
{
    return self;
}

- (void)setTextureID:(GLuint)textureid
{
    _textureID = textureid;
}

- (GLuint)updateTexture:(GLuint)uSamplerLocal
{
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    glUniform1i(uSamplerLocal, 0);
    
    return _textureID;
}

- (GLuint)updateTexture:(GLuint)uSamplerLocal ByTextureID:(int)index
{
    glActiveTexture(GL_TEXTURE0+index);
    
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    glUniform1i(uSamplerLocal, index);
    
    return _textureID;
}

- (CVPixelBufferRef)updateVideoTexture:(EAGLContext *)context
{
    return nil;
}

- (void)destory
{
    if (_textureID) glDeleteTextures(1, &(_textureID));
}

- (void)dealloc
{
    [self destory];
}

@end
