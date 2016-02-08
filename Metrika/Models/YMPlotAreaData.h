//
// Created by Dmitry Korotchenkov on 09.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class YMPlotPoint;


@interface YMPlotAreaData : NSObject

@property (nonatomic) CGPoint startPlotPoint;
@property (nonatomic) CGPoint endPlotPoint;
@property (nonatomic) CGPoint startGridPoint;
@property (nonatomic) CGPoint endGridPoint;
@property (nonatomic) CGFloat gridXSpace;
@property (nonatomic) CGFloat gridYSpace;

- (CGFloat)zeroSpaceY:(CGRect)rectForPlot;

- (CGFloat)zeroSpaceX:(CGRect)rectForPlot;

- (CGFloat)kX:(CGRect)rectForPlot;

- (CGFloat)kY:(CGRect)rectForPlot;
@end