//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMSourcesSummary.h"

@implementation YMSourcesSummary

@dynamic name;
@dynamic visits;
@dynamic visitsDelayed;
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
            @"depth",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
            @"visits_delayed" : @"visitsDelayed",
    }];
    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"name"];
    return mapping;
}

- (NSString *)mainValue {
    return self.name;
}

@end