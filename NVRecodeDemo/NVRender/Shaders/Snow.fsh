precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;
/*
vec2 uv;
#define _SnowflakeAmount 30    // Number of snowflakes
#define _BlizardFactor 0.2     // Fury of the storm !


float rnd(float x)
{
    return fract(sin(dot(vec2(x+47.49,38.2467/(x+2.3)), vec2(12.9898, 78.233))));
}

float drawCircle(vec2 center, float radius)
{
    return 1.0 - smoothstep(0.0, radius, length(uv - center));
}

void main()
{
    vec2 screen = vec2(750.0, 1334.0);
    vec2 fragCoord = vTexCoord.xy * screen.xy;
    uv = fragCoord.xy / screen.x;
    
    gl_FragColor = texture2D(uSampler,vTexCoord);
    
    float j;
    vec4 snow;
    
    for(int i=0; i<_SnowflakeAmount; i++)
    {
        j = float(i);
        float speed = 0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(_SnowflakeAmount)*0.25)));
        vec2 center = 1.0 - vec2((0.25-uv.y)*_BlizardFactor+rnd(j)+0.1*cos(uTime+sin(j)), mod(sin(j)-speed*(uTime*1.5*(0.1+_BlizardFactor)), 0.65));
        gl_FragColor += vec4(0.09*drawCircle(center, 0.001+speed*0.012));
    }
}*/

#define pi 3.1415926

float T;

// iq's hash function from https://www.shadertoy.com/view/MslGD8
vec2 hash( vec2 p ) {
    p = vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
    return fract(sin(p));
}

float simplegridnoise(vec2 v)
{
    float s = 1. / 256.;
    vec2 fl = floor(v), fr = fract(v);
    float mindist = 1e9;
    for(int y = -1; y <= 1; y++)
        for(int x = -1; x <= 1; x++)
        {
            vec2 offset = vec2(x, y);
            vec2 pos = .5 + .5 * cos(2. * pi * (T*.1 + hash(fl+offset)) + vec2(0,1.6));
            mindist = min(mindist, length(pos+offset -fr));
        }
    
    return mindist;
}

float blobnoise(vec2 v, float s)
{
    return pow(.5 + .5 * cos(pi * clamp(simplegridnoise(v)*2., 0., 1.)), s);
}

float fractalblobnoise(vec2 v, float s)
{
    float val = 0.;
    const float n = 4.;
    for(float i = 0.; i < n; i++)
        val += pow(0.5, i+1.) * blobnoise(exp2(i) * v + vec2(0, T), s);
    
    return val;
}

void main()
{
    T = uTime;
    
    vec2 r = vec2(1.0, 16.0 / 9.0);
    vec2 uv = vTexCoord;
    float val = fractalblobnoise(r * uv * 10.0, 5.0);
    //float val = blobnoise(r * uv * 10.0, 5.0);
    gl_FragColor = texture2D(uSampler, uv) + vec4(vec3(val), 1.0);
    //gl_FragColor = mix(texture2D(uSampler, uv), vec4(1.0), vec4(val));
}
