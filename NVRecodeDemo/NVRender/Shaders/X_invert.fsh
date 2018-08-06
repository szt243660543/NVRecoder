precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;

void main(){
    vec2 uv = vTexCoord;
    
    gl_FragColor = vec4(1.) - texture2D(uSampler, uv);
}
