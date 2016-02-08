//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMAbstractChildEntity.h"


@implementation YMAbstractChildEntity

@dynamic parentId;
@dynamic token;
@dynamic parentDateStart;
@dynamic parentDateEnd;
@dynamic lang;

+ (RKEntityMapping *)mapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    [mapping addAttributeMappingsFromDictionary:@{
            @"@root.id" : @"parentId",
            @"@root.token" : @"token",
            @"@root.lang" : @"lang",
            @"@root.date1":@"parentDateStart",
            @"@root.date2":@"parentDateEnd"
    }];
    mapping.identificationAttributes = @[@"parentId",@"token",@"lang",@"parentDateEnd",@"parentDateStart"];
    return mapping;
}


@end