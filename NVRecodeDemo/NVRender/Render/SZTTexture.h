//
//  SZTTexture.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTTexture : NSObject
{
    GLuint _textureID;
}

/**
 * 设置纹理ID
 * @param image 图片
 */
- (SZTTexture *)setupTextureWithImage:(UIImage *)image;

- (SZTTexture *)createTextureWithPath:(NSString *)path;

- (void)setTextureID:(GLuint)textureid;

/**
 * 更新纹理
 * @param context 上下文
 * @param uSamplerLocal
 */
- (GLuint)updateTexture:(GLuint)uSamplerLocal;

- (GLuint)updateTexture:(GLuint)uSamplerLocal ByTextureID:(int)index;

- (CVPixelBufferRef)updateVideoTexture:(EAGLContext *)context;

/**
 * 销毁
 */
- (void)destory;

@end
