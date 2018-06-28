//
//  NVFbo.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import <Foundation/Foundation.h>

@interface NVFbo : NSObject

- (instancetype)initWithFboWidth:(int)width height:(int)height;

@property(nonatomic, assign)CVPixelBufferRef renderTarget;

- (void)bind;

- (void)unbind;

- (void)render;

@end
