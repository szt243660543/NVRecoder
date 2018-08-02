precision mediump float;
varying highp vec2 vTexCoord;
uniform sampler2D uSampler;

uniform float scale;

void main(){
    vec2 newTextureCoordinate = vec2((scale - 1.0) *0.5 + vTexCoord.x / scale ,(scale - 1.0) *0.5 + vTexCoord.y /scale);
    
    vec4 textureColor = texture2D(uSampler, newTextureCoordinate);
    
    vec4 shiftColor1 = texture2D(uSampler, newTextureCoordinate+vec2(-0.05 * (scale - 1.0), - 0.05 *(scale - 1.0)));
    
    vec4 shiftColor2 = texture2D(uSampler, newTextureCoordinate+vec2(-0.1 * (scale - 1.0), - 0.1 *(scale - 1.0)));
    
    vec3 blendFirstColor = vec3(textureColor.r , textureColor.g, shiftColor1.b);
    
    vec3 blend3DColor = vec3(shiftColor2.r, blendFirstColor.g, blendFirstColor.b);
    
    gl_FragColor = vec4(blend3DColor, textureColor.a);
}

