precision mediump float;
varying highp vec2 vTexCoord;
uniform sampler2D uSampler;

void main(){
    float uv_x;
    if (vTexCoord.x > 0.5) {
        uv_x = 1.0 - vTexCoord.x;
    }else{
        uv_x = vTexCoord.x;
    }
    
    vec2 uv_earth = vec2(uv_x, vTexCoord.y);
    gl_FragColor = texture2D(uSampler, uv_earth);
}
