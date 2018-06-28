//
//  NVPlane.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/28.
//

#import "NVPlane.h"

@implementation NVPlane

- (instancetype)initWithRect:(CGRect)rect
{
    self = [super init];
    
    if (self) {
        generatePlane(rect, self);
    }
    
    return self;
}

void generatePlane(CGRect rect, NVDrawShape* object3D)
{
    float *points = (float*) malloc(12*sizeof(float));
    
    float origin_x = rect.origin.x;
    float origin_y = rect.origin.y;
    float ratioWidth = rect.size.width;
    float ratioHeight = rect.size.height;
    
    
    float tpoints[12] = {
        origin_x * 2.0 - 1.0, origin_y * 2.0 - 1.0, 0.0,
        origin_x * 2.0 - 1.0 + ratioWidth * 2.0 , origin_y * 2.0 - 1.0, 0.0,
        origin_x * 2.0 - 1.0, origin_y * 2.0 - 1.0 + ratioHeight * 2.0, 0.0,
        origin_x * 2.0 - 1.0 + ratioWidth * 2.0, origin_y * 2.0 - 1.0 + ratioHeight * 2.0, 0.0
    };
    
    memcpy(points, tpoints, 12*sizeof(float));
    
    float *texcoords = (float*)malloc(8*sizeof(float));
    
    float ttexcoords[8] ={0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f};
    memcpy(texcoords, ttexcoords, 8*sizeof(float));
    
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
