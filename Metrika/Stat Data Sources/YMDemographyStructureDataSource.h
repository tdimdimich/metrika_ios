//
// Created by Dmitry Korotchenkov on 13/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramAbstractDataSource.h"

@class YMDemographyStructureWrapper;


@interface YMDemographyStructureDataSource : YMDiagramAbstractDataSource
- (YMDemographyStructureDataSource *)initWithContent:(YMDemographyStructureWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;
@end