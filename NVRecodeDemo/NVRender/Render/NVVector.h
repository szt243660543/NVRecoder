//
//  NVVector.h
//  NVISION
//
//  Created by Mac on 2018/1/9.
//
//

#import <CoreGraphics/CGBase.h>

#ifndef NVVector_h
#define NVVector_h

struct NVVector2f {
    float x;
    float y;
};
typedef struct NVVector2f NVVector2f;

struct NVVector3f {
    float x;
    float y;
    float z;
};
typedef struct NVVector3f NVVector3f;

struct NVVector4f {
    float x;
    float y;
    float z;
    float w;
};
typedef struct NVVector4f NVVector4f;

CG_INLINE NVVector2f NVPosition2f(float x, float y)
{
    NVVector2f pos;
    pos.x = x;
    pos.y = y;
    
    return pos;
}

CG_INLINE NVVector3f NVPosition(float x, float y, float z)
{
    NVVector3f pos;
    pos.x = x;
    pos.y = y;
    pos.z = z;
    
    return pos;
}

CG_INLINE NVVector4f NVPosition4f(float x, float y, float z, float w)
{
    NVVector4f pos;
    pos.x = x;
    pos.y = y;
    pos.z = z;
    pos.w = w;
    
    return pos;
}

CG_INLINE NVVector3f NVMultiply(NVVector3f pos, float multi)
{
    return NVPosition(pos.x * multi, pos.y * multi, pos.z * multi);
}

CG_INLINE NVVector2f NVMultiply2f(NVVector2f pos, float multi)
{
    return NVPosition2f(pos.x * multi, pos.y * multi);
}

CG_INLINE NVVector3f NVAdd(NVVector3f pos, NVVector3f newpos)
{
    NVVector3f res;
    res.x = pos.x + newpos.x;
    res.y = pos.y + newpos.y;
    res.z = pos.z + newpos.z;
    return res;
}

CG_INLINE NVVector3f NVSubtraction(NVVector3f pos, NVVector3f newpos)
{
    NVVector3f res;
    res.x = pos.x - newpos.x;
    res.y = pos.y - newpos.y;
    res.z = pos.z - newpos.z;
    return res;
}

CG_INLINE float NVDistance(NVVector3f pos, NVVector3f newpos)
{
    float distance = 0.0;
    NVVector3f res;
    res.x = (pos.x - newpos.x) * (pos.x - newpos.x);
    res.y = (pos.y - newpos.y) * (pos.y - newpos.y);
    res.z = (pos.z - newpos.z) * (pos.z - newpos.z);
    
    distance = sqrt(res.x + res.y + res.z);
    
    return distance;
}

CG_INLINE float NVDistance2f(NVVector2f pos, NVVector2f newpos)
{
    float distance = 0.0;
    NVVector2f res;
    res.x = (pos.x - newpos.x) * (pos.x - newpos.x);
    res.y = (pos.y - newpos.y) * (pos.y - newpos.y);
    
    distance = sqrt(res.x + res.y);
    
    return distance;
}

CG_INLINE float NVLenth(NVVector3f pos)
{
    return sqrt(pos.x * pos.x + pos.y * pos.y + pos.z * pos.z);
}

#endif
