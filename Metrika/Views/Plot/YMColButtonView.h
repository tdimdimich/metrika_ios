//
// Created by Dmitry Korotchenkov on 20/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMColGroup;
@class YMGradientColor;


@interface YMColButtonView : UIView

@property(nonatomic, strong) YMColGroup *group;

- (id)initWithGroup:(YMColGroup *)group color:(YMGradientColor *)color;

- (void)setHighlighted:(BOOL)highlighted;

- (void)setSelected:(BOOL)selected;

+ (YMColButtonView *)buttonWithGroup:(YMColGroup *)group color:(YMGradientColor *)color;

@end