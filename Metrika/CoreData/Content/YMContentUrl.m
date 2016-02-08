//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentUrl.h"


@implementation YMContentUrl

@dynamic name;
@dynamic pageViews;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"name",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"page_views" : @"pageViews",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObjectsFromArray:@[@"name"]];
    return mapping;
}

- (NSString *)mainValue {
    return self.name;
}

@end