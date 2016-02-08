//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "YMDemographyStructureWrapper.h"
#import "YMDemographyStructure.h"
#import "NSString+DKAdditions.h"


@implementation YMDemographyStructureWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMDemographyStructure mapping]];
    return mapping;
}

- (CGFloat)malePercent {
    __block CGFloat total = 0;
    [self.data.allObjects bk_each:^(YMDemographyStructure *sender) {
        if ([[sender.gender lowercaseString] matchesSubstring:@"муж"] > 0) {
            total += sender.visitsPercent.floatValue;
        }
    }];
    return total;
}

- (CGFloat)femalePercent {
    __block CGFloat total = 0;
    [self.data.allObjects bk_each:^(YMDemographyStructure *sender) {
        if ([[sender.gender lowercaseString] matchesSubstring:@"жен"] > 0) {
            total += sender.visitsPercent.floatValue;
        }
    }];
    return total;
}

@end