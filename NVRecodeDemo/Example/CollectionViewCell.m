//
//  CollectionViewCell.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/8/23.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.cover];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.cover.frame), self.frame.size.width, 20.0)];
        self.title.font = [UIFont systemFontOfSize:13.0];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
    }
    
    return self;
}

@end
