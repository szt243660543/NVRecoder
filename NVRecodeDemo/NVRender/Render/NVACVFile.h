//
//  NVACVFile.h
//  NVRecodeDemo
//
//  Created by Mac on 2018/8/14.
//

#import <Foundation/Foundation.h>

@interface NVACVFile : NSObject

- (instancetype)initWithACVFileData:(NSData *)data;

@property(readonly,strong,nonatomic) NSArray *rgbCompositeCurvePoints;
@property(readonly,strong,nonatomic) NSArray *redCurvePoints;
@property(readonly,strong,nonatomic) NSArray *greenCurvePoints;
@property(readonly,strong,nonatomic) NSArray *blueCurvePoints;

@end
