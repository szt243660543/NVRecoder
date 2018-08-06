precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;

void main(){
    float speed = 1.75; // 颜色变换速率
    
    vec2 uv = vTexCoord;
    gl_FragColor = texture2D(uSampler, uv) + vec4((cos(uv.x + uTime * speed * 4.0) + 1.0) / 2.0,
                                                  (uv.x + uv.y) / 2.0,
                                                  (sin(uv.y + uTime * speed) + 1.0) / 2.0,
                                                  0.0
                                                  );
    
}

