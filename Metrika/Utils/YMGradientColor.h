//
// Created by Dmitry Korotchenkov on 01.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMGradientColor : NSObject <NSCoding>
@property(nonatomic, strong) UIColor *startColor;
@property(nonatomic, strong) UIColor *endColor;

- (id)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (BOOL)isEqualToColor:(YMGradientColor *)other;

+ (YMGradientColor *)colorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
@end