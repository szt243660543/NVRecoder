precision mediump float;
varying highp vec2 vTexCoord;

uniform sampler2D uSampler;
uniform sampler2D uSampler2;
uniform lowp float mixturePercent;
uniform highp float scalePercent;

uniform float scale;

void main() {
    lowp vec4 textureColor = texture2D(uSampler, vTexCoord);
    
    highp vec2 textureCoordinateToUse = vTexCoord;
    highp vec2 center = vec2(0.5, 0.5);
    textureCoordinateToUse -= center;
    textureCoordinateToUse = textureCoordinateToUse / scalePercent;
    textureCoordinateToUse += center;
    lowp vec4 textureColor2 = texture2D(uSampler, textureCoordinateToUse); // uSampler2
    
    gl_FragColor = mix(textureColor, textureColor2, mixturePercent);
}

