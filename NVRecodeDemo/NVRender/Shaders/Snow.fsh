precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;

const vec2 resolution = vec2(750.0, 1334.0);

/*
void main( void )
{
//    vec2 pos = 1.0 - 4.*gl_FragCoord.xy/resolution.xy;
    vec2 pos = 1.0 - vTexCoord.xy/0.1;
    pos *= vec2(resolution.x / resolution.y, 1.);

    // 火苗的抖动
    if(pos.y>-2.*4.2)
    {
        for(float baud = 1.; baud < 9.; baud += 1.)
        {
            pos.y += 0.2*sin(4.20*uTime/(1.+baud))/(1.+baud);
            pos.x += 0.1*cos(pos.y/4.20+2.40*uTime/(1.+baud))/(1.+baud);
        }
        pos.y += 0.04*fract(sin(uTime*60.));
    }
    
    // 火苗外焰
    vec3 color = vec3(0.,0.,0.);
    float p =.004;
    float y = -pow(abs(pos.x), 4.2)/p;   // 外焰的形状，注意pos.x负数会被截断
    float dir = abs(pos.y - y)*sin(.3);  // 外焰的大小（扩大渐变区域）
    //float dir = abs(pos.y - y)*(0.01*sin(time)+0.07);
    if(dir < 0.7)
    {
        color.rg += smoothstep(0.,1.,.75-dir);   // 外焰颜色渐变
        color.g /=2.4;                           // 减点绿
    }
    color *= (0.2 + abs(pos.y/4.2 + 4.2)/4.2);  // 增加对比度
    color += pow(color.r, 1.1);                 // 加点红
    color *= cos(-0.5+pos.y*0.4);               // 隐藏底部的颜色
    
    // 火苗内焰
    pos.y += 1.5;
    vec3 dolor = vec3(0.,0.,0.0);
    y = -pow(abs(pos.x), 4.2)/(4.2*p)*4.2;   // 内焰的形状，注意和外焰的次幂，越接近越不容易穿帮
    dir = abs(pos.y - y)*sin(1.1);           // 内焰的大小（扩大渐变区域）
    if(dir < 0.7)
    {
        dolor.bg += smoothstep(0., 1., .75-dir);// 内焰颜色渐变
        dolor.g /=2.4;
    }
    dolor *= (0.2 + abs((pos.y/4.2+4.2))/4.2);
    dolor += pow(color.b,1.1);                 // 加点蓝
    dolor *= cos(-0.6+pos.y*0.4);
    //dolor.rgb -= pow(length(dolor)/16., 0.5);
    
    color = (color+dolor)/2.;
    gl_FragColor = vec4(vec3(color) , 1.0);
}
*/

/*
#define PI 3.14159265359
#define T (uTime / .99)

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 4.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

const float aoinParam1 = 0.7;

float snow(vec2 uv,float scale)
{
    float w=smoothstep(9.,0.,-uv.y*(scale/10.));if(w<.1)return 0.;
    uv+=(uTime*aoinParam1)/scale;uv.y+=uTime*0./scale;uv.x+=sin(uv.y+uTime*.05)/scale;
    uv*=scale;vec2 s=floor(uv),f=fract(uv),p;float k=3.,d;
    p=.5+.35*sin(11.*fract(sin((s+p+scale)*mat2(7,3,6,5))*5.))-f;d=length(p);k=min(d,k);
    k=smoothstep(0.,k,sin(f.x+f.y)*0.01);
    return k*w;
}

void main( void ) {
    vec2 resolution = vec2(750.0, 1334.0);
    vec2 position = ((gl_FragCoord.xy / resolution.xy ) - 0.5);
    position.x *= resolution.x / resolution.y;
    
    vec3 color = vec3(0.);
    
    for (float i = 0.; i < PI*2.0; i += PI/20.0) {
        vec2 p = position - vec2(cos(i), sin(i)) * 0.15;
        vec3 col = hsv2rgb(vec3((i + T)/(PI*2.0), 1., 1));
        color += col * (2./512.) / length(p);
    }
    
    vec2 uv= 1.0 - (gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
    vec3 finalColor=vec3(0);
    float c=smoothstep(1.,0.3,clamp(uv.y*.3+.8,0.,.75));
    c+=snow(uv,30.)*.3;
    c+=snow(uv,20.)*.5;
    c+=snow(uv,15.)*10.8;
    c+=snow(uv,10.);
    c+=snow(uv,8.);
    c+=snow(uv,6.);
    c+=snow(uv,5.);
    finalColor=(vec3(c));
//    texture2D(uSampler, vTexCoord) +
    gl_FragColor = vec4(finalColor, 1.0) / vec4(2, 2, 2, 1);//(vec4( color, 1.0 ) + vec4(finalColor, 1.0)) / vec4(2, 2, 2, 1);
}
*/

/*
vec2 uv;
#define _SnowflakeAmount 200    // Number of snowflakes
#define _BlizardFactor 0.25     // Fury of the storm !


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
    uv = gl_FragCoord.xy / screen.x;
    
    gl_FragColor = texture2D(uSampler, vTexCoord);
    
    float j;
    
    for(int i=0; i<_SnowflakeAmount; i++)
    {
        j = float(i);
        float speed = 0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(_SnowflakeAmount)*0.25)));
        vec2 center = 1.0 - vec2((-0.25 + uv.y) * _BlizardFactor + rnd(j)+ 0.1 * cos(uTime + sin(j)),
             mod(rnd(j)- speed* (uTime * 1.5* (0.1 + _BlizardFactor)),0.95));

        gl_FragColor += vec4(0.09*drawCircle(center, 0.001+speed*0.012));
    }
}
*/


/*
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
*/
