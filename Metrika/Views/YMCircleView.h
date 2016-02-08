//
// File: YMCircleView.h
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMGradientColor;


@interface YMCircleView : UIView
@property (nonatomic) BOOL selected;
@property (nonatomic, strong) UIColor *color; // TODO: переделать! тут должен быть UIColor!
@end