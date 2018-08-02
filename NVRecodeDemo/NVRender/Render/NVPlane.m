//
//  NVPlane.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVPlane.h"

@interface NVPlane()
{
    int     _contentMode;
}

@end

@implementation NVPlane

- (instancetype)initWithRect:(CGSize)size contentMode:(int)mode size:(CGSize)videoSize
{
    self = [super init];
    
    if (self) {
        _contentMode = mode;
        generatePlane(size, self, mode, videoSize);
    }
    
    return self;
}

void generatePlane(CGSize size, NVDrawShape* object3D, int mode, CGSize videoSize)
{
    float *points = (float*) malloc(12*sizeof(float));
    
    float s_w = [UIScreen mainScreen].bounds.size.width;

    float ratioWidth = size.width/s_w;
//    float ratioHeight = size.height/s_w;
    
//    float tpoints[12] = {
//        -ratioWidth * 0.5, -ratioHeight * 0.5, 0.0,
//        ratioWidth * 0.5 , -ratioHeight * 0.5, 0.0,
//        -ratioWidth * 0.5, ratioHeight * 0.5, 0.0,
//        ratioWidth * 0.5, ratioHeight * 0.5, 0.0
//    };
    
    float ratioHeight = size.height/s_w;
    
    float tpoints[12] = {
        0.0,        0.0,         0.0,
        ratioWidth, 0.0,         0.0,
        0.0,        ratioHeight, 0.0,
        ratioWidth, ratioHeight, 0.0
    };
    
    memcpy(points, tpoints, 12*sizeof(float));
    
    float *texcoords = (float*)malloc(8*sizeof(float));
    
    if (mode == 1){
        float r = videoSize.width/videoSize.height;
        float s_r = size.width/size.height;
        
        if (r > s_r) {
            float x_offset = s_r / r / 2;
            float ttexcoords[8] ={0.5 - x_offset, 0.0f, 0.5 + x_offset, 0.0f, 0.5 - x_offset, 1.0f, 0.5 + x_offset, 1.0f};
            memcpy(texcoords, ttexcoords, 8*sizeof(float));
        }else{
            float y_offset = r / s_r / 2;
            float ttexcoords[8] ={0.0, 0.5 - y_offset, 1.0, 0.5 - y_offset, 0.0, 0.5 + y_offset, 1.0, 0.5 + y_offset};
            memcpy(texcoords, ttexcoords, 8*sizeof(float));
        }
    }else{
//        float ttexcoords[8] ={0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f};
        float ttexcoords[8] ={1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f};
        memcpy(texcoords, ttexcoords, 8*sizeof(float));
    }
    
    short* indices = (short*)malloc(6*sizeof(short));
    short tindices[6] = {2, 0, 1, 2, 1, 3};
    memcpy(indices, tindices, 6*sizeof(short));
    
    if(indices != NULL) [object3D setIndicesBuffer:indices size:6];
    if(texcoords != NULL) [object3D setTextureBuffer:texcoords size:8];
    if(points != NULL) [object3D setVertexBuffer:points size:12];
    [object3D setNumIndices:6];
    
    if(indices!=NULL)
    {
        free(indices);
        indices = NULL;
    }
    
    if(texcoords!=NULL){
        free(texcoords);
        texcoords = NULL;
    }
    
    if(points !=NULL){
        free(points);
        points = NULL;
    }
}

@end
