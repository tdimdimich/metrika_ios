//
// Created by Dmitry Korotchenkov on 30.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class YMGradientColor;

static const int kCircleColorButtonDiameter = 32;
static const int kCircleColorButtonInnerDiameter = 26;

@interface YMCircleColorButton : UIButton
@property(nonatomic, readonly) UIColor *color;
+ (YMCircleColorButton *)buttonWithCenterPosition:(CGPoint)centerPosition color:(UIColor *)color;
@end