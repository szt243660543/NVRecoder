precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;
float d;

float lookup(vec2 p, float dx, float dy)
{
    vec2 screen = vec2(750, 1334.0);
    vec2 uv = (p.xy + vec2(dx * d, dy * d)) / screen.xy;
    vec4 c = texture2D(uSampler, uv.xy);
    
    // return as luma
    return 0.2126*c.r + 0.7152*c.g + 0.0722*c.b;
}

void main(){
    vec2 screen = vec2(750, 1334.0);
    d = sin(uTime * 5.0)*0.5 + 1.5; // kernel offset
    vec2 p = vTexCoord.xy * screen.xy;
    
    // simple sobel edge detection
    float gx = 0.0;
    gx += -1.0 * lookup(p, -1.0, -1.0);
    gx += -2.0 * lookup(p, -1.0,  0.0);
    gx += -1.0 * lookup(p, -1.0,  1.0);
    gx +=  1.0 * lookup(p,  1.0, -1.0);
    gx +=  2.0 * lookup(p,  1.0,  0.0);
    gx +=  1.0 * lookup(p,  1.0,  1.0);
    
    float gy = 0.0;
    gy += -1.0 * lookup(p, -1.0, -1.0);
    gy += -2.0 * lookup(p,  0.0, -1.0);
    gy += -1.0 * lookup(p,  1.0, -1.0);
    gy +=  1.0 * lookup(p, -1.0,  1.0);
    gy +=  2.0 * lookup(p,  0.0,  1.0);
    gy +=  1.0 * lookup(p,  1.0,  1.0);
    
    // hack: use g^2 to conceal noise in the video
    float g = gx*gx + gy*gy;
    float g2 = g * (sin(uTime) / 2.0 + 0.5);
    
    vec4 col = texture2D(uSampler, p / screen.xy);
    col += vec4(0.0, g, g2, 1.0);
    
    gl_FragColor = col;
}
