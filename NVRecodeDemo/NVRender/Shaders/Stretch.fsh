precision mediump float;
varying highp vec2 vTexCoord;
uniform sampler2D uSampler;

uniform highp vec2 center;

void main(){    
    vec2 normCoord = 2.0 * vTexCoord - 1.0;
    vec2 normCenter = 2.0 * center - 1.0;
    
    normCoord -= normCenter;
    vec2 s = sign(normCoord);
    normCoord = abs(normCoord);
    normCoord = 0.5 * normCoord + 0.5 * smoothstep(0.25, 0.5, normCoord) * normCoord;
    normCoord = s * normCoord;
    
    normCoord += normCenter;
    
    vec2 textureCoordinateToUse = normCoord / 2.0 + 0.5;
    
    gl_FragColor = texture2D(uSampler, textureCoordinateToUse);
}
