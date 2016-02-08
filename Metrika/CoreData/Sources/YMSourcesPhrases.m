//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "YMSourcesPhrases.h"
#import "YMSourcesPhrasesSearchEngines.h"


@implementation YMSourcesPhrases

@dynamic id;
@dynamic phrase;
@dynamic visits;
@dynamic pageViews;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;
@dynamic searchEngines;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addAttributeMappingsFromArray:@[
            @"phrase",
            @"id",
            @"visits",
            @"denial",
            @"depth",
    ]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"visit_time" : @"visitTime",
            @"page_views" : @"pageViews",
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"search_engines" toKeyPath:@"searchEngines" withMapping:[YMSourcesPhrasesSearchEngines mapping]]];

    mapping.identificationAttributes = [mapping.identificationAttributes arrayByAddingObject:@"id"];
    return mapping;
}

- (NSString *)mainValue {
    return self.phrase;
}

@end