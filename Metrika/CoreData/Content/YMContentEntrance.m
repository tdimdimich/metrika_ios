//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentEntrance.h"


@implementation YMContentEntrance

@dynamic url;
@dynamic visits;
@dynamic pageViews;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"url",
            @"visits",
            @"denial",
            @"depth"
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObjectsFromArray:@[@"url"]];
    return mapping;
}

- (NSString *)mainValue {
    return self.url;
}

@end