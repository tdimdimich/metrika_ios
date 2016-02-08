//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMTechBrowsersWrapper.h"
#import "YMTechBrowsers.h"
#import "RKEntityMapping.h"


@implementation YMTechBrowsersWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTechBrowsers mapping]];
    return mapping;
}

@end