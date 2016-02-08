//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMTechBrowsers.h"


@implementation YMTechBrowsers

@dynamic name;
@dynamic version;
@dynamic visits;
@dynamic pageViews;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"name",
            @"version",
            @"visits",
            @"denial",
            @"depth"
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObjectsFromArray:@[@"name", @"version"]];
    return mapping;
}

- (NSString *)mainValue {
    return self.name;
}

@end