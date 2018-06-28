//
//  Shader_Normal.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Normal_h
#define Shader_Normal_h
#import "Shader.h"

NSString *const NormalVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    varying lowp vec2 vTexCoord;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        gl_Position = modelViewProjectionMatrix * position;
    
        vTexCoord = aTexCoord;
    }
);

NSString *const NormalFragmentShaderString = SHADER_STRING
(
    precision mediump float;
    uniform sampler2D uSampler;
    varying lowp vec2 vTexCoord;
 
    void main()
    {
        vec4 texCol = texture2D(uSampler, vTexCoord);
    
        gl_FragColor = vec4(texCol.rgb, 1.0);
    }
);


#endif /* Shader_Normal_h */
