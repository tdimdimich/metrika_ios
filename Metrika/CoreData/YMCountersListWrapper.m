//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMCountersListWrapper.h"
#import "YMCounter.h"

@implementation YMCountersListWrapper

@dynamic token;
@dynamic lang;
@dynamic counters;

+ (RKEntityMapping *)mapping {

    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"token" : @"token",
            @"lang" : @"lang"
    }];

    [mapping addRelationshipMappingWithSourceKeyPath:@"counters" mapping:[YMCounter mapping]];
    mapping.identificationAttributes = @[@"token", @"lang"];
    return mapping;
}

@end