//
//  NVObject.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import "NVObject.h"

@interface NVObject()
{
    float _screenWidth;
    float _screenHeight;
}

@end

@implementation NVObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _mModelMatrix = GLKMatrix4Identity;
        
        _scale = NVPosition(1.0, 1.0, 1.0);
        _rotation = NVPosition(0.0, 0.0, 0.0);
        _z = -1.0;
        _frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

- (void)setPosition:(NVVector3f)position
{
    float ratio = _screenHeight/_screenWidth;
    float z = fabsf(position.z);
    
    _mModelMatrix = GLKMatrix4TranslateWithVector3(_mModelMatrix, GLKVector3Make((position.x/_screenWidth - 0.5) * z, (position.y/_screenWidth - ratio * 0.5) * z, position.z));
}

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    
    [self transformation];
}

- (void)setZ:(float)z
{
    _z = z;
    
    [self transformation];
}
    
- (void)setScale:(NVVector3f)scale
{
    _scale = scale;
    
    [self transformation];
}

- (void)setRotation:(NVVector3f)rotation
{
    _rotation = rotation;
    
    [self transformation];
}

- (void)transformation
{
    _mModelMatrix = GLKMatrix4Identity;
    // 缩放->旋转->平移
    
    // 缩放
    _mModelMatrix = GLKMatrix4Scale(_mModelMatrix, _scale.x, _scale.y, _scale.z);
    
    // 旋转
    _mModelMatrix = GLKMatrix4RotateX(_mModelMatrix, _rotation.x);
    _mModelMatrix = GLKMatrix4RotateY(_mModelMatrix, _rotation.y);
    _mModelMatrix = GLKMatrix4RotateZ(_mModelMatrix, _rotation.z);
    
    // 平移
    [self setPosition:NVPosition(_frame.origin.x, _frame.origin.y, self.z)];
}

@end
