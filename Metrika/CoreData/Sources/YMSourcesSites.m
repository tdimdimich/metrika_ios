//
// Created by Dmitry Korotchenkov on 02.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMSourcesSites.h"
#import "RKRelationshipMapping.h"


@implementation YMSourcesSites

@dynamic url;
@dynamic urlFull;
@dynamic id;
@dynamic visits;
@dynamic pageViews;

@dynamic denial;
@dynamic depth;
@dynamic visitTime;

@dynamic child;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"url",
            @"visits",
            @"denial",
            @"depth",
            @"id"
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
            @"url_full" : @"urlFull"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"chld" toKeyPath:@"child" withMapping:mapping]];

    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"id"];
    return mapping;
}

- (NSString *)mainValue {
    return self.urlFull;
}

@end