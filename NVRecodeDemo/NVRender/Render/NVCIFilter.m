//
//  NVFilter.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/8/2.
//

#import "NVCIFilter.h"

@interface NVCIFilter()
{
    CIContext *_coreImageContext;
    CIFilterMode _ciFilter;
}

@property(nonatomic, strong)CIFilter *coreImageFilter;

@end

@implementation NVCIFilter

- (instancetype)initWithFilterMode:(CIFilterMode)ciFilter
{
    self = [super init];
    
    if (self) {
        _ciFilter = ciFilter;
        [self setupCIContext];
        
        [self setupFilter];
    }
    
    return self;
}

- (void)setupCIContext
{
    if (!_coreImageContext) {
        _coreImageContext = [CIContext contextWithEAGLContext:[EAGLContext currentContext] options:nil];
    }
}

- (void)setupFilter
{
    CIFilter *filter;
    
    switch (_ciFilter) {
        case CIPhotoEffectInstant:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
        }
            break;
        case CIPhotoEffectMono:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
        }
            break;
        case CIPhotoEffectNoir:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
        }
            break;
        case CIPhotoEffectFade:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
        }
            break;
        case CIPhotoEffectTonal:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
        }
            break;
        case CIPhotoEffectProcess:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
        }
            break;
        case CIPhotoEffectTransfer:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
        }
            break;
        case CIPhotoEffectChrome:{
            filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
        }
            break;
        case CIVibrance:{
            filter = [CIFilter filterWithName:@"CIVibrance"];
        }
            break;
        default:
            break;
    }
    
    self.coreImageFilter = filter;
}

- (CVPixelBufferRef)coreImageHandle:(CVPixelBufferRef)pixelBuffer
{
    CIImage *inputImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    [self setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = [self.coreImageFilter outputImage];
    [_coreImageContext render:outputImage toCVPixelBuffer:pixelBuffer];
    
    return pixelBuffer;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.coreImageFilter setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key
{
    return [self.coreImageFilter valueForKey:key];
}

@end
