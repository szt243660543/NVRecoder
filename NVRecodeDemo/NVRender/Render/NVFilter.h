//
//  NVFilter.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/8/2.
//

#import <Foundation/Foundation.h>

// 参数调整看官方demo
// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIZoomBlur

typedef NS_ENUM(NSInteger, CIFilterMode) {
    CIPhotoEffectInstant,   // 怀旧
    CIPhotoEffectMono,      // 单色
    CIPhotoEffectNoir,      // 黑白
    CIPhotoEffectFade,      // 褪色
    CIPhotoEffectTonal,     // 色调
    CIPhotoEffectProcess,   // 冲印
    CIPhotoEffectTransfer,  // 岁月
    CIPhotoEffectChrome,    // 铬黄
    CIVibrance,             // 鲜艳       // inputAmount
};

@interface NVFilter : NSObject

- (instancetype)initWithFilterMode:(CIFilterMode)ciFilter;

- (CVPixelBufferRef)coreImageHandle:(CVPixelBufferRef)pixelBuffer;

@end
