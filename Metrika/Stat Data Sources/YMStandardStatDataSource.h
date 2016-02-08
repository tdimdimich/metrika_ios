//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"

@class YMTechMobileWrapper;

@interface YMStandardStatDataSource : YMDiagramAbstractDataSource

- (YMStandardStatDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd needGrouping:(BOOL)needGrouping;

- (void)addDataWithName:(NSString *)name visits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime;

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode;
@end