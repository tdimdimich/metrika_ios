//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMTechJava.h"


@implementation YMTechJava

@dynamic name;
@dynamic visits;
@dynamic pageViews;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"name",
            @"visits",
            @"denial",
            @"depth"
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObjectsFromArray:@[@"name"]];
    return mapping;
}

- (NSString *)mainValue {
    return self.name;
}

@end