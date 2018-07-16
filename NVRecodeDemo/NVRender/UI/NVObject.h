//
//  NVObject.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/6/29.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "NVVector.h"

@interface NVObject : NSObject

@property(nonatomic, assign)CGRect frame;

@property(nonatomic, assign)float z;
    
@property(nonatomic, assign)NVVector3f scale;
    
@property(nonatomic, assign)NVVector3f rotation;

@property(nonatomic, assign)GLKMatrix4 mModelMatrix;

@end
