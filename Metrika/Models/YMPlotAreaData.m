//
// Created by Dmitry Korotchenkov on 09.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMPlotAreaData.h"
#import "YMPlotPoint.h"


@implementation YMPlotAreaData

- (CGFloat)zeroSpaceY:(CGRect)rectForPlot {
    return -self.startPlotPoint.y * [self kY:rectForPlot];
}

- (CGFloat)zeroSpaceX:(CGRect)rectForPlot {
    return -self.startPlotPoint.x * [self kX:rectForPlot];
}

- (CGFloat)kX:(CGRect)rectForPlot {
    return rectForPlot.size.width / (self.endPlotPoint.x - self.startPlotPoint.x);
}

- (CGFloat)kY:(CGRect)rectForPlot {
    return rectForPlot.size.height / (self.endPlotPoint.y - self.startPlotPoint.y);
}

@end