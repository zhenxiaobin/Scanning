//
//  SMBackButton.m
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import "SMBackButton.h"

#define kScreenScale [UIScreen mainScreen].bounds.size.width/320.0

@implementation SMBackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView
{
    UIImage* image = [UIImage imageNamed:@"signIn_nav_back_btn"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, 10*kScreenScale, 14.5*kScreenScale);
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.target respondsToSelector:self.action]) {
        
        [self.target performSelector:self.action withObject:nil];
    }
}
@end
