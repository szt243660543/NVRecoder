precision mediump float;
varying vec2 vTexCoord;
uniform sampler2D uSampler;

void main(){
    float _Radius = 0.5;
    vec2 uv = vTexCoord;
    
    vec4 textureColor = texture2D(uSampler, uv);

    if(uv.x<0.5 && uv.y>0.5)
    {
        vec2 r;
        r.x = 0.5 - uv.x;
        r.y = uv.y - 0.5;
        if(length(r)>_Radius)//以r.x、r.y为两直角边长度，计算斜边长度
        {
            discard;
        }
        else
        {
            gl_FragColor = textureColor;
        }
    }
    
    else if(uv.x<0.5 && uv.y<0.5)
    {
        vec2 r;
        r.x = 0.5 - uv.x;
        r.y = 0.5 - uv.y;
        if(length(r)>_Radius)
        {
            discard;
        }
        else
        {
            gl_FragColor = textureColor;
        }
    }
    
    else if(uv.x>0.5 && uv.y>0.5)
    {
        vec2 r;
        r.x = uv.x - 0.5;
        r.y = uv.y - 0.5;
        if(length(r)>_Radius)
        {
            discard;
        }
        else
        {
            gl_FragColor =  textureColor;
        }
    }
    
    else if(uv.x>0.5 && uv.y<0.5)
    {
        vec2 r;
        r.x = uv.x - 0.5;
        r.y = 0.5 - uv.y;
        if(length(r)>_Radius)
        {
            discard;
        }
        else
        {
            gl_FragColor =  textureColor;
        }
    }
}
