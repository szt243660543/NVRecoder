//
//  NVProgram.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/25.
//

#import <Foundation/Foundation.h>

@interface NVProgram : NSObject
{
    NSMutableArray  *attributes;
    NSMutableArray  *uniforms;
}

@property(nonatomic, assign)GLuint program;

@property(nonatomic, assign)GLuint vertexHandle;

@property(nonatomic, assign)GLuint texCoordHandle;

@property(nonatomic, assign)GLuint uSamplerLocal;

@property(nonatomic, assign)GLuint mvp;

/**
 * 加载纹理
 * @param vertShader 顶点着色器
 * @param fragShader 片段着色器
 * @param isFilePath 是否是文本路径
 */
- (void)loadShaders:(NSString *)vertShader FragShader:(NSString *)fragShader isFilePath:(BOOL)isfile;

- (void)addAttribute:(NSString *)attributeName;

- (GLuint)uniformIndex:(NSString *)uniformName;

- (GLuint)attributeIndex:(NSString *)attributeName;

/**
 * 使用Program
 */
- (void)useProgram;

- (void)defaultProgram;

/**
 * 销毁
 */
- (void)destory;

@end
