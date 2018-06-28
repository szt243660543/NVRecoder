//
//  NVDrawShape.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import <Foundation/Foundation.h>
#import "NVProgram.h"

@interface NVDrawShape : NSObject

@property (nonatomic, assign)float* mVertexBuffer;
@property (nonatomic, assign)float* mTextureBuffer;
@property (nonatomic, assign)short* mIndicesBuffer;
@property (nonatomic, assign)int mNumIndices;
@property (nonatomic, assign)int mNumVertes;
@property (nonatomic, assign)int mNumTextures;

- (void)setupDefaultData;

- (void)drawElements:(NVProgram *)program;
- (void)drawElementsFBO:(NVProgram *)program;

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setIndicesBuffer:(short *)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setNumIndices:(int)value;

- (void)destroy;

@end
