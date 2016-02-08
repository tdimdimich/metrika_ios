//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"


@interface YMContentUrlDataSource : YMDiagramAbstractDataSource
- (YMContentUrlDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode;
@end