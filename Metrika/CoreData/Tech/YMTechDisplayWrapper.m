//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "YMTechDisplayWrapper.h"
#import "YMTechDisplay.h"


@implementation YMTechDisplayWrapper

@dynamic data;
@dynamic dataGroup;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTechDisplay mapping]];
    RKRelationshipMapping *groutDataMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"data_group"
                                                                                          toKeyPath:@"dataGroup"
                                                                                        withMapping:[YMTechDisplay mapping]];
    [mapping addPropertyMapping:groutDataMapping];
    return mapping;
}

@end