//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMDemographyStructure.h"


@implementation YMDemographyStructure

@dynamic name;
@dynamic id;
@dynamic visits;
@dynamic visitsPercent;
@dynamic gender;
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
            @"visits_percent" : @"visitsPercent",
            @"visit_time" : @"visitTime",
            @"id" : @"id",
            @"name_gender" : @"gender"
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObjectsFromArray:@[@"name", @"gender"]];
    return mapping;
}

@end