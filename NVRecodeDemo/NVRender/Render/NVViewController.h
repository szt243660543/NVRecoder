//
//  ViewController.h
//
//  Created by Mac on 2018/6/23.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "NVRenderObject.h"

@interface NVViewController : GLKViewController

- (void)addRenderTarget:(NVRenderObject *)object;

- (void)removeRenderTarget:(NVRenderObject *)object;

- (CVPixelBufferRef)getSurfaceBuffer;

@end
