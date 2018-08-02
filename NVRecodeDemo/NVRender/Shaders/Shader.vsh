//
//  Shader.vsh
//  simpleFBO
//
//  Created by Mahesh Venkitachalam on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec2 aTexCoord;

varying vec2 vTexCoord;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    
    vTexCoord = aTexCoord;
}
