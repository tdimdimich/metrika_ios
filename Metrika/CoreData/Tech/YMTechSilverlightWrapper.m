//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMTechSilverlightWrapper.h"
#import "YMTechSilverlight.h"


@implementation YMTechSilverlightWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTechSilverlight mapping]];
    return mapping;
}

@end