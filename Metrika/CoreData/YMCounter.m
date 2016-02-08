//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMCounter.h"


@implementation YMCounter

@dynamic id;
@dynamic site;
@dynamic codeStatus;
@dynamic permission;
@dynamic name;
@dynamic type;
@dynamic ownerLogin;
@dynamic token;
@dynamic lang;

+ (RKEntityMapping *)mapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[
            @"site",
            @"permission",
            @"name",
            @"id",
            @"type"
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"owner_login" : @"ownerLogin",
            @"code_status" : @"codeStatus",
            @"@parent.token" : @"token",
            @"@parent.lang" : @"lang"
    }];
    mapping.identificationAttributes = @[@"token", @"id", @"lang"];
    return mapping;
}

@end