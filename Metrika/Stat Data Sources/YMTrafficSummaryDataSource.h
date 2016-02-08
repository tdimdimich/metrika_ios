//
// Created by Dmitry Korotchenkov on 12/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMUtils.h"
#import "YMGraphDataSource.h"

@class YMPointPlotData;
@class YMColsPlotData;
@class YMPlotData;


@interface YMTrafficSummaryDataSource : NSObject <YMGraphDataSource>

@property(nonatomic) NSUInteger selectedTypeIndex;
@property(nonatomic) YMInterval selectedInterval;

- (id)initWithTrafficContent:(NSArray *)trafficContent dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

@end