//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMCheckButton.h"

@class YMColGroup;
@class YMGradientColor;
@class YMColButtonView;


@interface YMColButton : UIButton

@property(nonatomic, strong) YMColButtonView *colView;

- (id)initWithGroup:(YMColGroup *)group color:(YMGradientColor *)color;

+ (YMColButton *)buttonWithGroup:(YMColGroup *)group color:(YMGradientColor *)color;
@end