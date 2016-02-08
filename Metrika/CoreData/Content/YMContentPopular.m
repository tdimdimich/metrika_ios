//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "YMContentPopular.h"


@implementation YMContentPopular

@dynamic url;
@dynamic id;
@dynamic urlFull;
@dynamic pageViews;
@dynamic exit;
@dynamic entrance;
@dynamic child;
@dynamic parent;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"url",
            @"exit",
            @"entrance",
            @"id",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"page_views" : @"pageViews",
            @"url_full" : @"urlFull"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"chld" toKeyPath:@"child" withMapping:mapping]];

    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"id"];
    return mapping;
}

- (NSString *)domainName {
    return [[self rootElement] url];
}

- (YMContentPopular *)rootElement {
    if (self.parent != nil)
        return [self.parent rootElement];
    else
        return self;
}

@end