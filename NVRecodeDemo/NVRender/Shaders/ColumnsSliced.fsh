precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;
uniform float uTime;

vec2 rotateCoord(vec2 uv, float rads) {
    uv *= mat2(cos(rads), sin(rads), -sin(rads), cos(rads));
    return uv;
}

void main()
{
    float columns = 1.;//4. + 3.5 * sin(uTime);
    float columnWidth = 1. / columns;
    float scrollProgress = 0.5 + 1./2. * sin(3.14 + uTime);
    float zoom = 2. + 0.5 * sin(uTime);
    float aspect = 9./16.;
    float padding = 0.15 + 0.15 * sin(uTime);
    vec4 color = vec4(1.);
    
    // get coordinates, rotate & fix aspect ratio
    vec2 screen = vec2(750, 1334.0);
    vec2 fragCoord = vTexCoord.xy * screen.xy;
    
    vec2 uv = (2. * fragCoord - screen.xy) / screen.y;
    uv = rotateCoord(uv, 0.2 * sin(uTime));
    uv.y *= aspect; // fix aspect ratio
    
    // create grid coords & set color
    vec2 uvRepeat = fract(uv * zoom);
    
    // calc columns and scroll/repeat them
    float colIndex = floor(uvRepeat.x * columns) + 1.;
    float yStepRepeat = colIndex * scrollProgress;
    uvRepeat += vec2(0., yStepRepeat);
    uvRepeat = fract(uvRepeat);
    
    // add padding
    uvRepeat.y *= 1. + padding;
    uvRepeat.y -= padding;
    uvRepeat.x *= (columnWidth + padding * 1.) * columns;
    uvRepeat.x -= padding * colIndex;
    if(uvRepeat.y > 0. && uvRepeat.y < 1.) {
        if(uvRepeat.x < columnWidth * colIndex && uvRepeat.x > columnWidth * (colIndex - 1.)) {
            color = texture2D(uSampler, uvRepeat);
        }
    }
    
    // set it / forget it
    gl_FragColor = color;
}
