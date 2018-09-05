precision mediump float;
varying highp vec2 vTexCoord;
uniform sampler2D uSampler;

uniform highp float aspectRatio;
uniform highp vec2 center;
uniform highp float radius;
uniform highp float scale;

void main(){    
    highp vec2 vTexCoordToUse = vec2(vTexCoord.x, ((vTexCoord.y - center.y) * aspectRatio) + center.y);
    highp float dist = distance(center, vTexCoordToUse);
    vTexCoordToUse = vTexCoord;
    
    if (dist < radius)
    {
        vTexCoordToUse -= center;
        highp float percent = 1.0 - ((radius - dist) / radius) * scale;
        percent = percent * percent;
        
        vTexCoordToUse = vTexCoordToUse * percent;
        vTexCoordToUse += center;
    }
    
    gl_FragColor = texture2D(uSampler, vTexCoordToUse);
}

//void main(){
//    float radius = 0.2;
//    float centerX = 0.5;
//    float centerY = 0.5;
//    float newX = 0.0;
//    float newY = 0.0;
//
//    float tx = vTexCoord.x-centerX;
//    float ty = vTexCoord.y-centerY;
//    float distan = tx*tx+ty*ty;
//
//    float real_radius = radius/2.0;
//    if(distan < radius * radius){
//        newX = tx/2.0;
//        newY = ty/2.0;
//        newX = newX * (sqrt(distan)/real_radius);
//        newY = newY * (sqrt(distan)/real_radius);
//        newX = newX + centerX;
//        newY = newY + centerY;
//    }else{
//        newX = vTexCoord.x;
//        newY = vTexCoord.y;
//    }
//
//    float u_x = newX;
//    float u_y = newY;
//    vec2 nv_earth = vec2(u_x, u_y);
//
//    gl_FragColor = texture2D(uSampler, nv_earth);
//}
