//
//  NVRenderObject.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import <Foundation/Foundation.h>
#import "NVProgram.h"
#import "NVDrawShape.h"

typedef NS_ENUM(NSInteger, SZTFilterMode) {
    SZTVR_NORMAL,           // 普通
    SZTVR_LUMINANCE,        // 像素色值亮度平均，图像黑白 (黑白效果)
    SZTVR_PIXELATE,         // 马赛克
    SZTVR_EXPOSURE,         // 曝光 (美白)
    SZTVR_DISCRETIZE,       // 离散
    SZTVR_BLUR,             // 模糊
    SZTVR_BILATERAL,        // 双边模糊
    SZTVR_HUE,              // 饱和度
    SZTVR_POLKADOT,         // 像素圆点花样
    SZTVR_GAMMA,            // 伽马线
    SZTVR_GLASSSPHERE,      // 水晶球效果
    SZTVR_CROSSHATCH,       // 法线交叉线
};

@interface NVRenderObject : NSObject

- (void)setShapeObject:(CGRect)rect;

- (void)render;

- (void)destory;

- (void)updateTexture;

/**
 * 修改滤波器
 */
- (void)changeFilter:(SZTFilterMode)filterMode;

@property(nonatomic, strong)NVProgram *program;

@property(nonatomic, strong)NVDrawShape *shape;

@property(nonatomic, assign)SZTFilterMode filterMode;

#pragma mark - SZTVideoFilter property
// SZTVR_PIXELATE 模式
@property(nonatomic, assign)float particles;

// SZTVR_BLUR 模式
@property(nonatomic, assign)float radius;

// SZTVR_HUE 模式
@property(nonatomic ,assign)float hueAdjust;

// SZTVR_POLKADOT 模式
@property(nonatomic ,assign)float fractionalWidthOfPixel;
@property(nonatomic ,assign)float aspectRatio;
@property(nonatomic ,assign)float dotScaling;

// SZTVR_CROSSHATCH 模式
@property(nonatomic, assign)float crossHatchSpacing;
@property(nonatomic, assign)float lineWidth;

// SZTVR_EXPOSURE 模式
@property(nonatomic ,assign)float exposure;

// SZTVR_GAMMA 模式 (0.0 ~ <1.0 变亮 && >1.0 变暗)
@property(nonatomic ,assign)float gamma;

// SZTVR_GLASSSPHERE 模式
@property(nonatomic ,assign)float refractiveIndex;

- (void)setupFilterMode;

@end
