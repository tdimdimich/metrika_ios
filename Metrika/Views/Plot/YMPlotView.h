//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMUtils.h"

@class YMPointPlotData;
@class YMPlotAreaData;
@class YMGradientColor;
@class YMPlotData;
@class YMPlotView;

@protocol YMPlotViewDelegate

@optional

-(NSArray *)plotView:(YMPlotView *)plotView titlesForXValue:(CGFloat)x;

-(NSString *)plotView:(YMPlotView *)plotView titleForYValue:(CGFloat)y;

- (void)didSelectInterval:(YMInterval)interval;

@end

@interface YMPlotView : UIView

@property(nonatomic, weak) id delegate;

@property(nonatomic, strong) YMPlotData *plotData;

@property(nonatomic, strong) NSMutableArray *xLabels;

@property (nonatomic) YMInterval selectedInterval;

@property(nonatomic) BOOL needUpdateToSelectedInterval;

- (id)initWithFrame:(CGRect)frame plotData:(YMPlotData *)plotData color:(YMGradientColor *)color delegate:(NSObject <YMPlotViewDelegate> *)delegate;

- (void)setSelectedInterval:(YMInterval)interval;

// 0 - clear all selections, 1 - one point selected, 2 - two points selected;
- (NSUInteger)modeForInterval:(YMInterval)interval;

- (CGRect)rectForPlot:(CGRect)rect;

- (UIColor *)bgColor;
@end