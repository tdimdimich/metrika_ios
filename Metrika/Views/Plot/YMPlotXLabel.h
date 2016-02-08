//
// Created by Dmitry Korotchenkov on 01.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum {
    YMPlotXLabelTextPositionCenter,
    YMPlotXLabelTextPositionTop,
    YMPlotXLabelTextPositionBottom
} YMPlotXLabelTextPosition;

static const int kPlotXLabelViewHeight = 28;

@interface YMPlotXLabel : UIView
@property (nonatomic) BOOL selected;

@property(nonatomic) CGFloat value;

- (id)initWithFirstLineText:(NSString *)firstText secondLineText:(NSString *)secondText value:(CGFloat)value;

- (void)showArrow:(BOOL)yesNo;
@end