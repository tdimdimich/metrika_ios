//
// Created by Dmitry Korotchenkov on 14/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"

@class YMContentPopularWrapper;


@interface YMContentPopularDataSource : YMDiagramAbstractDataSource
- (YMContentPopularDataSource *)initWithContent:(YMContentPopularWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;
@end