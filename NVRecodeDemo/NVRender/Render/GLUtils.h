//
//  GLUtils.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLUtils : NSObject

/**
 * 加载着色器
 * @type shader类型
 * @shaderFilepath sharder资源路径
 */
+ (GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath;

/**
 * 加载program
 * @shaderVertex 顶点着色器
 * @shaderFragment 片段着色器
 * @return 返回program
 */
+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment isFilePath:(BOOL)isfile;

/**
 *  @传入图片的路径
 *  @return 返回纹理对象
 */
+ (GLuint)setupTextureWithFileName:(NSString *)fileName;

/**
 *  @传入UIimage
 *  @return 返回纹理对象
 */
+ (GLuint)setupTextureWithImage:(UIImage *)image;

//+ (void)setGLTextureMinFilter:(SZTTextureFilter)textureFilter;

+ (int)NextPot:(int)n;\

@end
