//
// Created by Dmitry Korotchenkov on 29.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMTrafficDeepnessWrapper.h"
#import "YMTrafficDeepness.h"
#import "RKEntityMapping.h"
#import "RKRelationshipMapping.h"


@implementation YMTrafficDeepnessWrapper

@dynamic dataTime;
@dynamic dataDepth;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    RKRelationshipMapping *timeMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"data_time" toKeyPath:@"dataTime" withMapping:[YMTrafficDeepness mapping]];
    RKRelationshipMapping *depthMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"data_depth" toKeyPath:@"dataDepth" withMapping:[YMTrafficDeepness mapping]];
    [mapping addPropertyMappingsFromArray:@[timeMapping,depthMapping]];
    return mapping;
}

@end
