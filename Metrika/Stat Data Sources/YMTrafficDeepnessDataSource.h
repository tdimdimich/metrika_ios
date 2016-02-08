//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"


@interface YMTrafficDeepnessDataSource : YMDiagramAbstractDataSource
- (YMTrafficDeepnessDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;
@end