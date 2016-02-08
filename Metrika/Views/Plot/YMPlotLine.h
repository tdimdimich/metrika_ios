//
// Created by Dmitry Korotchenkov on 28.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class YMGradientColor;


@interface YMPlotLine : UIView
@property(nonatomic) BOOL selected;

- (id)initWithColor:(YMGradientColor *)color;

+ (YMPlotLine *)lineWithColor:(YMGradientColor *)color;

- (void)setStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end