//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "YMSourcesSummaryWrapper.h"
#import "YMSourcesSummary.h"

@implementation YMSourcesSummaryWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMSourcesSummary mapping]];
    return mapping;
}

@end