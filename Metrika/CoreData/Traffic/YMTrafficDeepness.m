//
// Created by Dmitry Korotchenkov on 29.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMTrafficDeepness.h"


@implementation YMTrafficDeepness


@dynamic name;
@dynamic visits;
@dynamic percent;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"name",
            @"visits",
            @"denial",
            @"depth",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visits_percent" : @"percent",
            @"visit_time" : @"visitTime"
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"name"];
    return mapping;
}

@end