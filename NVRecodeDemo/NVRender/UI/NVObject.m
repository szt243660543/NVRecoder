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
        self.z = -1.0;
    }
    
    return self;
}

- (void)setPosition:(NVVector3f)position
{
    self.mModelMatrix = GLKMatrix4Identity;
    float ratio = _screenHeight/_screenWidth;
    float z = fabsf(position.z);
    
    _mModelMatrix = GLKMatrix4TranslateWithVector3(_mModelMatrix, GLKVector3Make((position.x/_screenWidth - 0.5) * z, (position.y/ _screenWidth - ratio * 0.5) * z, position.z));
}

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    
    [self setPosition:NVPosition(frame.origin.x, frame.origin.y, self.z)];
}

- (void)setZ:(float)z
{
    _z = z;
    
    [self setPosition:NVPosition(_frame.origin.x, _frame.origin.y, z)];
}

@end
