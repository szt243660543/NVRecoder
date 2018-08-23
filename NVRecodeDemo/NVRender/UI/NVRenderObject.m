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
#import "NVGLCamera.h"
#import "NVToneCurveTexture.h"

@interface NVRenderObject ()
{
    NSTimeInterval _startTime;
    
    int            _frameIndex;
    
    // 色调混合纹理
    NVToneCurveTexture *_toneCurveTexture;
}

@end

@implementation NVRenderObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self changeFilter:SZTVR_NORMAL];
        
        _startTime = [NSDate timeIntervalSinceReferenceDate];
    }
    
    return self;
}

- (void)setShapeObject:(CGSize)size
{
    if (self.shape) {
        [self.shape destroy];
        self.shape = nil;
    }
    
    int nmode = self.contentMode?self.contentMode:0;
    NVPlane *plane = [[NVPlane alloc] initWithRect:size contentMode:nmode size:self.videoSize];
    self.shape = plane;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setShapeObject:frame.size];
}

- (void)setContentMode:(NVContentMode)contentMode
{
    _contentMode = contentMode;
    
    [self setShapeObject:self.frame.size];
}

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    
    [self destoryProgram];
    
    _program = [[NVProgram alloc] init];
    
    switch (filterMode) {
        case SZTVR_NORMAL:{
//            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
//            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Shader.fsh" ofType:nil];
//            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
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
        case BEAUTY_FILTER:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"BeautyFilter.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
            
            _toneLevel = 0.47;
            _beautyLevel = 0.42;//0.42;
            _brightLevel = 0.0;//0.34;
        }
            break;
        case BULGE:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Bulge.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
            
            _d_radius = 0.4;
            _d_scale = 0.35;
            _d_aspectRatio = 1280.0/720.0;
            _d_center_point = CGPointMake(0.5, 0.5);
        }
            break;
        case STRETCH:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Stretch.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
            
            _s_center_point = CGPointMake(0.5, 0.5);
        }
            break;
        case FAKE3D:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Fake3D.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
            
            _frameIndex = 0;
        }
            break;
        case SOUL_SCALE:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Soul_Scale.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
            
            _frameIndex = 0;
        }
            break;
        case HALLUCINATION:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Hallucination.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case MULTICOLOURED:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Multicoloured.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case OLD_VIDEO:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"OldVideo.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case X_INVERT:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"X_invert.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case EDGE_SHINE:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"EdgeShine.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case TONE_CURVE:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"ToneCurve.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case COLUMNS_SLICED:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"ColumnsSliced.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        case SNOW:{
            NSString * v_path = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
            NSString * f_path = [[NSBundle mainBundle] pathForResource:@"Snow.fsh" ofType:nil];
            [_program loadShaders:v_path FragShader:f_path isFilePath:YES];
        }
            break;
        default:
            break;
    }
}

- (void)loadACVFileUrl:(NSURL *)curveFileURL
{
    if (_toneCurveTexture) {
        [_toneCurveTexture destory];
        _toneCurveTexture = nil;
    }
    
    NSData* fileData = [NSData dataWithContentsOfURL:curveFileURL];
    
    _toneCurveTexture = [[NVToneCurveTexture alloc] initWithACVData:fileData];
}

- (void)updateFilterMode
{
    double cur_time = [NSDate timeIntervalSinceReferenceDate];
    double time = cur_time - _startTime ;

    glUniform1f([self.program uniformIndex:@"uTime"], time);
    if(time > 2.0*3.1415)
    {
        _startTime = cur_time;
    }
    
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
    
    if (self.filterMode == BEAUTY_FILTER) {
        GLKVector4 fBeautyParam;
        fBeautyParam.x = 1.0 - 0.6 * _beautyLevel;
        fBeautyParam.y = 1.0 - 0.3 * _beautyLevel;
        fBeautyParam.z = 0.1 + 0.3 * _toneLevel;
        fBeautyParam.w = 0.1 + 0.3 * _toneLevel;
        CGPoint offset = CGPointMake(1.0f / 720.0, 1.0 / 1280.0);
        GLfloat positionArray[2];
        positionArray[0] = offset.x;
        positionArray[1] = offset.y;
        glUniform2fv([_program uniformIndex:@"singleStepOffset"] ,1, positionArray);
        glUniform4fv([_program uniformIndex:@"params"], 1, (GLfloat *)&fBeautyParam);
        glUniform1f([_program uniformIndex:@"brightness"], _brightLevel);
    }
    
    if (self.filterMode == BULGE) {
        GLfloat point[2];
        point[0] = self.d_center_point.x;
        point[1] = self.d_center_point.y;
    
        glUniform1f([_program uniformIndex:@"radius"], self.d_radius);
        glUniform1f([_program uniformIndex:@"scale"], self.d_scale);
        glUniform2fv([_program uniformIndex:@"center"] ,1, point);
        glUniform1f([_program uniformIndex:@"aspectRatio"], self.d_aspectRatio);
    }
    
    if (self.filterMode == STRETCH) {
        GLfloat point[2];
        point[0] = self.s_center_point.x;
        point[1] = self.s_center_point.y;
        
        glUniform2fv([_program uniformIndex:@"center"] ,1, point);
    }
    
    if (self.filterMode == FAKE3D) {
        NSArray * dy_scale = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.07],
                                    [NSNumber numberWithFloat:1.1],
                                    [NSNumber numberWithFloat:1.13],
                                    [NSNumber numberWithFloat:1.17],
                                    [NSNumber numberWithFloat:1.2],
                                    [NSNumber numberWithFloat:1.2],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:1.0],
                                    nil];
        
        if (_frameIndex >= dy_scale.count) {
            _frameIndex = 0;
        }
        self.dy_scale = [dy_scale[_frameIndex] floatValue];
        
        glUniform1f([_program uniformIndex:@"scale"], self.dy_scale);
        
        _frameIndex ++;
    }
    
    if (self.filterMode == SOUL_SCALE) {
        NSArray * mixturePercent = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.411498],
                                    [NSNumber numberWithFloat:0.340743],
                                    [NSNumber numberWithFloat:0.283781],
                                    [NSNumber numberWithFloat:0.237625],
                                    [NSNumber numberWithFloat:0.199993],
                                    [NSNumber numberWithFloat:0.169133],
                                    [NSNumber numberWithFloat:0.143688],
                                    [NSNumber numberWithFloat:0.122599],
                                    [NSNumber numberWithFloat:0.037117],
                                    [NSNumber numberWithFloat:0.028870],
                                    [NSNumber numberWithFloat:0.022595],
                                    [NSNumber numberWithFloat:0.017788],
                                    [NSNumber numberWithFloat:0.010000],
                                    [NSNumber numberWithFloat:0.010000],
                                    [NSNumber numberWithFloat:0.010000],
                                    [NSNumber numberWithFloat:0.010000],
                                    nil];
        
        NSArray * scalePercent = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:1.084553],
                                    [NSNumber numberWithFloat:1.173257],
                                    [NSNumber numberWithFloat:1.266176],
                                    [NSNumber numberWithFloat:1.363377],
                                    [NSNumber numberWithFloat:1.464923],
                                    [NSNumber numberWithFloat:1.570877],
                                    [NSNumber numberWithFloat:1.681300],
                                    [NSNumber numberWithFloat:1.796254],
                                    [NSNumber numberWithFloat:1.915799],
                                    [NSNumber numberWithFloat:2.039995],
                                    [NSNumber numberWithFloat:2.168901],
                                    [NSNumber numberWithFloat:2.302574],
                                    [NSNumber numberWithFloat:2.302574],
                                    [NSNumber numberWithFloat:2.302574],
                                    [NSNumber numberWithFloat:2.302574],
                                    [NSNumber numberWithFloat:2.302574],
                                    nil];
        if (_frameIndex >= mixturePercent.count) {
            _frameIndex = 0;
        }
        
        self.mixturePercent = [mixturePercent[_frameIndex] floatValue];
        self.scalePercent = [scalePercent[_frameIndex] floatValue];
        glUniform1f([_program uniformIndex:@"mixturePercent"], self.mixturePercent);
        glUniform1f([_program uniformIndex:@"scalePercent"], self.scalePercent);
        
        _frameIndex ++;
    }
    
    if (self.filterMode == TONE_CURVE) {
        [_toneCurveTexture updateTexture:[_program uniformIndex:@"toneCurveTexture"] ByTextureID:1];
    }
}

- (void)render
{
    [self.program useProgram];

    [self updateTexture];
//    if (![self updateTexture]) return;
    
    [self updateFilterMode];
    
    [self updateMvpMatrix];
    
    [self drawElements];
}

- (void)updateMvpMatrix
{
    GLKMatrix4 mvp = GLKMatrix4Multiply([NVGLCamera sharedNVGLCamera].mModelViewProjectionMatrix, self.mModelMatrix);
    glUniformMatrix4fv(self.program.mvp, 1, 0, mvp.m);
}

- (void)drawElements
{
    [self.shape drawElements:self.program];
}

- (BOOL)updateTexture
{
    return false;
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
