//
//  SMBackButton.h
//  Scanning
//
//  Created by tsmc on 15/6/30.
//  Copyright (c) 2015年 SevenMay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMBackButton : UIView

@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;

- (void)addTarget:(id)target action:(SEL)action;

@end
