//
// Created by Dmitry Korotchenkov on 18/11/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMGraphTypeButton.h"
#import "DKUtils.h"
#import "YMUtils.h"
#import "UIImage+DKAdditions.h"


@implementation YMGraphTypeButton
- (void)setColor:(UIColor *)color {
    [self setImage:[self imageForNormalStateWithColor:color] forState:UIControlStateNormal];
    [self setImage:[self imageForSelectedStateWithColor:color] forState:UIControlStateSelected];
}

- (UIImage *)imageForNormalStateWithColor:(UIColor *)color {
    // Mask image size: 42x22, white image: 17x18.
    UIImage *maskImage = [UIImage imageNamed:@"point-graph-icon-mask"];
    UIImage *whiteImage = [UIImage imageWithFrame:CGRectMake(0, 0, 17, 18) color:[UIColor whiteColor]];
    UIImage *maskedImage = [UIImage imageWithMaskImage:maskImage color:color];
    return [maskedImage insertImageBelowSelf:whiteImage withPosition:CGPointMake(2, 2)];
}

- (UIImage *)imageForSelectedStateWithColor:(UIColor *)color {
    // Mask image size: 42x22, white image: 17x18.
    UIImage *maskImage = [UIImage imageNamed:@"col-graph-icon-mask"];
    UIImage *whiteImage = [UIImage imageWithFrame:CGRectMake(0, 0, 17, 18) color:[UIColor whiteColor]];
    UIImage *maskedImage = [UIImage imageWithMaskImage:maskImage color:color];
    return [maskedImage insertImageBelowSelf:whiteImage withPosition:CGPointMake(23, 2)];
}

@end