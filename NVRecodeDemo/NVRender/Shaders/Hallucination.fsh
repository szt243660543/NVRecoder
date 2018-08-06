precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;

void main(){
    vec2 uv = vTexCoord;
    
    float amount = 0.0;

    amount = (1.0 + sin(uTime*6.0)) * 0.5;
    amount *= 1.0 + sin(uTime*16.0) * 0.5;
    amount *= 1.0 + sin(uTime*19.0) * 0.5;
    amount *= 1.0 + sin(uTime*27.0) * 0.5;
//    amount = pow(amount, 3.0); // 抖动程度

    amount *= 0.05;

    vec3 col;
    col.r = texture2D( uSampler, vec2(uv.x+amount,uv.y) ).r;
    col.g = texture2D( uSampler, uv ).g;
    col.b = texture2D( uSampler, vec2(uv.x-amount,uv.y) ).b;

    col *= (1.0 - amount * 0.5);
    
    gl_FragColor =  vec4(col, 1.0);
}

