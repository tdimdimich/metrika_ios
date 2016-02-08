//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMGraphDataSource.h"
#import "YMDiagramDataSource.h"
#import "YMDiagramAbstractDataSource.h"

@class YMSourcesSummaryWrapper;


@interface YMSourcesSummaryDataSource : YMDiagramAbstractDataSource

- (YMSourcesSummaryDataSource *)initWithContent:(YMSourcesSummaryWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

@end