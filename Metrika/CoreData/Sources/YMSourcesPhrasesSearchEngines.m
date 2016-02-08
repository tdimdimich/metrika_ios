//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMSourcesPhrasesSearchEngines.h"


@implementation YMSourcesPhrasesSearchEngines

@dynamic id;
@dynamic page;
@dynamic url;

+ (RKEntityMapping *)mapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    [mapping addAttributeMappingsFromDictionary:@{
            @"se_id" : @"id",
            @"se_page" : @"page",
            @"se_url" : @"url"
    }];
    mapping.identificationAttributes = @[@"id", @"page", @"url"];
    return mapping;
}

@end