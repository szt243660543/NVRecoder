//
//  Shader.fsh
//  simpleFBO
//
//  Created by Mahesh Venkitachalam on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

 precision mediump float;
 uniform sampler2D uSampler;
 varying vec2 vTexCoord;
 uniform float uTime;

// 水波纹1
//void main()
//{
//    vec2 uv = vTexCoord;
//    float w = (-0.1 - uv.x) * (9.0 / 16.0);
//    float h = (-0.1 - uv.y) * (9.0 / 16.0);;
//    float distanceFromCenter = sqrt(w * w + h * h);
//    float sinArg = distanceFromCenter * 5.0 - uTime * 5.0;
//    float slope = cos(sinArg);
//    vec4 color = texture2D(uSampler, uv + normalize(vec2(w, h)) * slope * 0.02);
//    gl_FragColor = color;
//}

 // 水波纹2
 vec2 params = vec2(2.5, 10.0);

 float wave(vec2 pos, float t, float freq, float numWaves, vec2 center)
 {
     float d = length(pos - center);
     d = log(1.0 + exp(d));
     return 1.0/(1.0+20.0*d*d) *sin(2.0*3.1415*(-numWaves*d + t * freq));
 }

float height(vec2 pos, float t)
{
    float w;
    w =  wave(pos, t, params.x, params.y, vec2(0.5, -0.5));
    w += wave(pos, t, params.x, params.y, -vec2(0.5, -0.5));
    return w;
}

vec2 normal(vec2 pos, float t)
{
    return vec2(height(pos - vec2(0.0015, 0), t) - height(pos, t),
                height(pos - vec2(0, 0.0015), t) - height(pos, t));
}

void main()
{
    vec2 uv = vTexCoord;
    vec2 uvn = 1.0*uv - vec2(1.0);
    uv += normal(uvn, uTime);
    gl_FragColor = texture2D(uSampler, vec2(uv.x, uv.y));
}

// 默认
// void main()
// {
//     vec4 texCol = texture2D(uSampler, vTexCoord);
//
//     gl_FragColor = texCol;
// }
