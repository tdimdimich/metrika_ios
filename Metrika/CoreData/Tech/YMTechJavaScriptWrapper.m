//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMTechJavaScriptWrapper.h"
#import "YMTechJavaScript.h"


@implementation YMTechJavaScriptWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTechJavaScript mapping]];
    return mapping;
}

@end