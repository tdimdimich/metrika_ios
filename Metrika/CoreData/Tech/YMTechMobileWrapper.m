//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "YMTechMobileWrapper.h"
#import "YMTechMobile.h"


@implementation YMTechMobileWrapper

@dynamic data;
@dynamic dataGroup;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTechMobile mapping]];
    RKRelationshipMapping *groutDataMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"data_group"
                                                                                          toKeyPath:@"dataGroup"
                                                                                        withMapping:[YMTechMobile mapping]];
    [mapping addPropertyMapping:groutDataMapping];
    return mapping;
}

@end