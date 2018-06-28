//
//  Shader_Blur.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//


#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#import "Shader_Normal.h"
#import "Shader_Luminance.h"
#import "Shader_Pixelate.h"
#import "Shader_Exposure.h"
#import "Shader_Discretize.h"
#import "Shader_Blur.h"
#import "Shader_Hue.h"
#import "Shader_PolkaDotFilter.h"
#import "Shader_Gamma.h"
#import "Shader_GlassSphere.h"
#import "Shader_Bilateral.h"
#import "Shader_Crosshatch.h"

