//
//  NVDrawShape.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVDrawShape.h"
#import <GLKit/GLKit.h>

typedef struct {
    float Position[3];
    float TexCoord[2];
} Vertex;

Vertex gVertexDataFullScreen[] =
{
    {{1.0f, 1.0f, 0.0f},{1.0f, 0.0f}},
    {{-1.0f, 1.0f, 0.0f},{0.0f, 0.0f}},
    {{1.0f, -1.0f, 0.0f},{1.0f, 1.0f}},
    {{-1.0f, -1.0f, 0.0f},{0.0f, 1.0f}}
};

GLubyte Indices[] = {
    0, 1, 2,
    2, 1, 3
};

@interface NVDrawShape ()
{
    GLuint _vertexBuffer;
    GLuint _texCoordBuffer;
    GLuint _indexBuffer;
}

@end

@implementation NVDrawShape

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupVBO];
    }
    
    return self;
}

- (void)setupDefaultData
{
    glBufferData(GL_ARRAY_BUFFER, sizeof(gVertexDataFullScreen), gVertexDataFullScreen, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)setupVBO
{
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
}

- (void)drawElements:(NVProgram *)program
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program.texCoordHandle, 2, GL_FLOAT, 0, 0, self.mTextureBuffer);
    glVertexAttribPointer(program.vertexHandle, 3, GL_FLOAT, 0, 0, self.mVertexBuffer);
    
    glDrawElements(GL_TRIANGLES, _mNumIndices, GL_UNSIGNED_SHORT, self.mIndicesBuffer);
}

- (void)drawElementsFBO:(NVProgram *)program
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program.texCoordHandle, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(program.vertexHandle, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)setVertexBuffer:(float*)buffer size:(int)size
{
    [self destroyVertexBuffer];
    
    int size_t = sizeof(float)*size;
    _mVertexBuffer = (float*)malloc(size_t);
    memcpy(_mVertexBuffer, buffer, size_t);
    
    self.mNumVertes = size;
}

- (void)setIndicesBuffer:(short *)buffer size:(int)size
{
    [self destroyIndicesBuffer];
    
    int size_t = sizeof(short)*size;
    _mIndicesBuffer = (short*)malloc(size_t);
    memcpy(_mIndicesBuffer, buffer, size_t);
}

- (void)setTextureBuffer:(float*)buffer size:(int)size
{
    [self destroyTextureBuffer];
    
    int size_t = sizeof(float)*size;
    _mTextureBuffer = (float*)malloc(size_t);
    memcpy(_mTextureBuffer, buffer, size_t);
    
    self.mNumTextures = size;
}

- (void)setNumIndices:(int)value
{
    _mNumIndices = value;
}

- (void)destroy
{
    [self destroyVertexBuffer];
    
    [self destroyTextureBuffer];
    
    [self destroyIndicesBuffer];
}

- (void)destroyVertexBuffer
{
    if (_mVertexBuffer != NULL){
        free(_mVertexBuffer);
        _mVertexBuffer = nil;
    }
}

- (void)destroyTextureBuffer
{
    if (_mTextureBuffer != NULL){
        free(_mTextureBuffer);
        _mTextureBuffer = nil;
    };
}

- (void)destroyIndicesBuffer
{
    if (_mIndicesBuffer != NULL){
        free(_mIndicesBuffer);
        _mIndicesBuffer = nil;
    };
}

-(void)dealloc
{
    [self destroy];
}

@end
