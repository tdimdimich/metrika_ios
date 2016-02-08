//
// Created by Dmitry Korotchenkov on 09.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMPlotPoint.h"


@implementation YMPlotPoint

+(YMPlotPoint *)pointWithX:(CGFloat)x y:(CGFloat)y {
    YMPlotPoint *point = [self new];
    point.x = x;
    point.y = y;
    return point;
}
@end