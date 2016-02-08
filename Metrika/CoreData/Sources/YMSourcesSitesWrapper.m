//
// Created by Dmitry Korotchenkov on 02.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMSourcesSitesWrapper.h"
#import "RKEntityMapping.h"
#import "YMSourcesSites.h"


@implementation YMSourcesSitesWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMSourcesSites mapping]];
    return mapping;
}

- (NSArray *)listOfObjects {
    return [self leafObjectsForArray:self.data.allObjects];
}

- (NSMutableArray *)leafObjectsForArray:(NSArray *)array {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (YMSourcesSites *sourcesSites in array) {
        if (sourcesSites.child.count == 0) {
            [returnArray addObject:sourcesSites];
        } else {
            [returnArray addObjectsFromArray:[self leafObjectsForArray:sourcesSites.child.allObjects]];
        }

    }
    return returnArray;
}

@end