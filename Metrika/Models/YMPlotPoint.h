//
// Created by Dmitry Korotchenkov on 09.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMPlotPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

+ (YMPlotPoint *)pointWithX:(CGFloat)x y:(CGFloat)y;
@end