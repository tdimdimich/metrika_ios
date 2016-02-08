//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMTrafficHourly.h"


@implementation YMTrafficHourly

@dynamic hours;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;
@dynamic avgVisit;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"hours",
            @"denial",
            @"depth",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"avg_visits" : @"avgVisit",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"hours"];
    return mapping;
}

@end