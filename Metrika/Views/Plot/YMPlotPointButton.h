//
// Created by Dmitry Korotchenkov on 28.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class YMPlotPoint;

typedef enum {
    YMPlotPointButtonSelectionNone,
    YMPlotPointButtonSelectionSmall,
    YMPlotPointButtonSelectionBig,
} YMPlotPointButtonSelection;

@interface YMPlotPointButton : UIButton
@property(nonatomic, strong) YMPlotPoint *point;
@property(nonatomic) YMPlotPointButtonSelection selection;

+ (YMPlotPointButton *)buttonWithPoint:(YMPlotPoint *)point innerColor:(UIColor *)innerColor outterColor:(UIColor *)outterColor;

@end