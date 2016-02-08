//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"

@class YMTrafficHourlyWrapper;


@interface YMTrafficHourlyDataSource : YMDiagramAbstractDataSource
- (YMTrafficHourlyDataSource *)initWithContent:(YMTrafficHourlyWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode;
@end