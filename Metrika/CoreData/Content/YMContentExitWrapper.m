//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentExitWrapper.h"
#import "YMContentExit.h"


@implementation YMContentExitWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMContentExit mapping]];
    return mapping;
}

@end