//
//  NVRenderObject.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVRenderObject.h"
#import "NVPlane.h"
#import "Shader.h"
#import "GLUtils.h"

@interface NVRenderObject ()
{
    GLuint texId;
}

@end

@implementation NVRenderObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupProgram];
        
        // 默认
        [self setShapeObject:CGRectMake(0, 0, 1.0, 1.0)];
    }
    
    return self;
}

- (void)setupProgram
{
    [self changeFilter:SZTVR_NORMAL];
}

- (void)setShapeObject:(CGRect)rect
{
    if (self.shape) {
        [self.shape destroy];
        self.shape = nil;
    }
    
    NVPlane *plane = [[NVPlane alloc] initWithRect:rect];
    self.shape = plane;
}

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    
    [self destoryProgram];
    
    _program = [[NVProgram alloc] init];
    
    switch (filterMode) {
        case SZTVR_NORMAL:{
            [_program loadShaders:NormalVertexShaderString FragShader:NormalFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_LUMINANCE:{
            [_program loadShaders:NormalVertexShaderString FragShader:LuminanceFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_PIXELATE:{
            [_program loadShaders:PixelateVertexShaderString FragShader:PixelateFragmentShaderString isFilePath:NO];
            _particles = 64;
        }
            break;
        case SZTVR_EXPOSURE:{
            [_program loadShaders:ExposureVertexShaderString FragShader:ExposureFragmentShaderString isFilePath:NO];
            _exposure = 0.0;
        }
            break;
        case SZTVR_DISCRETIZE:{
            [_program loadShaders:NormalVertexShaderString FragShader:DiscretizeFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_BLUR:{
            [_program loadShaders:BlurVertexShaderString FragShader:BlurFragmentShaderString isFilePath:NO];
            _radius = 0.02;
        }
            break;
        case SZTVR_HUE:{
            [_program loadShaders:HueVertexShaderString FragShader:HueFragmentShaderString isFilePath:NO];
            _hueAdjust = 90.0;
        }
            break;
        case SZTVR_POLKADOT:{
            [_program loadShaders:PolkaDotFilterVertexShaderString FragShader:PolkaDotFilterFragmentShaderString isFilePath:NO];
            _fractionalWidthOfPixel = 0.03;
            _aspectRatio = 1.0;
            _dotScaling = 0.90;
        }
            break;
        case SZTVR_GAMMA:{
            [_program loadShaders:GammaVertexShaderString FragShader:GammaFragmentShaderString isFilePath:NO];
            _gamma = 1.0;
        }
            break;
        case SZTVR_GLASSSPHERE:{
            [_program loadShaders:GlassSphereVertexShaderString FragShader:GlassSphereFragmentShaderString isFilePath:NO];
            _refractiveIndex = 0.71;
            _aspectRatio = 9.0/16.0;
            _radius = 0.25;
        }
            break;
        case SZTVR_BILATERAL:{
            [_program loadShaders:BilateralVertexShaderString FragShader:BilateralFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_CROSSHATCH:{
            [_program loadShaders:CrosshatchVertexShaderString FragShader:CrosshatchFragmentShaderString isFilePath:NO];
            _crossHatchSpacing = 0.05;
            _lineWidth = 0.005;
        }
            break;
        default:
            break;
    }
}

- (void)setupFilterMode
{
    if (self.filterMode == SZTVR_PIXELATE) {
        glUniform1f([_program uniformIndex:@"particles"], _particles);
    }
    
    if (self.filterMode == SZTVR_BLUR) {
        glUniform1f([_program uniformIndex:@"radius"], _radius);
    }
    
    if (self.filterMode == SZTVR_EXPOSURE) {
        glUniform1f([_program uniformIndex:@"exposure"], _exposure);
    }
    
    if (self.filterMode == SZTVR_HUE) {
        glUniform1f([_program uniformIndex:@"hueAdjust"], _hueAdjust);
    }
    
    if (self.filterMode == SZTVR_POLKADOT) {
        glUniform1f([_program uniformIndex:@"fractionalWidthOfPixel"], _fractionalWidthOfPixel);
        glUniform1f([_program uniformIndex:@"aspectRatio"], _aspectRatio);
        glUniform1f([_program uniformIndex:@"dotScaling"], _dotScaling);
    }
    
    if (self.filterMode == SZTVR_GAMMA) {
        glUniform1f([_program uniformIndex:@"gamma"], _gamma);
    }
    
    if (self.filterMode == SZTVR_GLASSSPHERE) {
        glUniform1f([_program uniformIndex:@"refractiveIndex"], _refractiveIndex);
        glUniform1f([_program uniformIndex:@"aspectRatio"], _aspectRatio);
        glUniform1f([_program uniformIndex:@"radius"], _radius);
    }
    
    if (self.filterMode == SZTVR_CROSSHATCH) {
        glUniform1f([_program uniformIndex:@"crossHatchSpacing"], _crossHatchSpacing);
        glUniform1f([_program uniformIndex:@"lineWidth"], _lineWidth);
    }
}

- (void)render
{
    [self.program useProgram];
    
    [self updateTexture];
    
    [self setupFilterMode];
    
    glUniformMatrix4fv(self.program.mvp, 1, 0, GLKMatrix4Identity.m);
    
    [self drawElements];
}

- (void)drawElements
{
    [self.shape drawElements:self.program];
}

- (void)updateTexture
{

}

- (void)destory
{
    [self destoryProgram];
    [self destoryShape];
}

- (void)destoryProgram
{
    if (_program) {
        [_program destory];
        _program = nil;
    }
}

- (void)destoryShape
{
    if (self.shape) {
        [self.shape destroy];
        self.shape = nil;
    }
}

- (void)dealloc
{
    [self destory];
}

@end
