//
//  NVRenderObject.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVObject.h"
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
    //------------特效-------------//
    BEAUTY_FILTER,          // 美颜 (美白,润色,磨皮)
    BULGE,                  // 哈哈镜 (凸)
    STRETCH,                // 拉伸
    FAKE3D,                 // 抖音抖动
    SOUL_SCALE,             // 灵魂出窍
    HALLUCINATION,          // 幻觉
    MULTICOLOURED,          // 五光十色
    OLD_VIDEO,              // 老旧视频
    X_INVERT,               // X光
    EDGE_SHINE,             // 边缘发光
    TONE_CURVE,             // 色调曲线滤镜
};

typedef NS_ENUM(NSInteger, NVContentMode) {
    NVModeScaleToFill,       // 填充
    NVModeScaleAspectFill,   // 从中间自适应填充
};

@interface NVRenderObject : NVObject
{
    BOOL _isFilp;
}

- (void)render;

- (void)destory;

- (BOOL)updateTexture;

/**
 * 修改滤波器
 */
- (void)changeFilter:(SZTFilterMode)filterMode;

// 仅适用于Filter为TONE_CURVE模式下
// curveFileURL = [[NSBundle mainBundle] URLForResource:curveFilename withExtension:@"acv"];
- (void)loadACVFileUrl:(NSURL *)curveFileURL;

@property(nonatomic, strong)NVProgram *program;

@property(nonatomic, strong)NVDrawShape *shape;

@property(nonatomic, assign)SZTFilterMode filterMode;

@property(nonatomic, assign)NVContentMode contentMode;

@property(nonatomic, assign)CGSize videoSize;

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

// BEAUTY_FILTRE
/** 美颜程度 */
@property (nonatomic, assign) CGFloat beautyLevel;
/** 美白程度 */
@property (nonatomic, assign) CGFloat brightLevel;
/** 色调强度 */
@property (nonatomic, assign) CGFloat toneLevel;

// DISTORTING_MIRROR
/** 影响半径 */
@property (nonatomic, assign) CGFloat d_radius;
/** 效果强度 */
@property (nonatomic, assign) CGFloat d_scale;
/** 坐标 */
@property (nonatomic, assign) CGPoint d_center_point;
@property (nonatomic, assign) CGFloat d_aspectRatio;

// STRETCH
@property (nonatomic, assign) CGPoint s_center_point;

// FAKE3D
@property (nonatomic, assign) CGFloat dy_scale;

// SOUL_SCALE
@property (nonatomic, assign) CGFloat mixturePercent;
@property (nonatomic, assign) CGFloat scalePercent;

// SZTVR_GLASSSPHERE 模式
@property(nonatomic ,assign)float refractiveIndex;

@end
