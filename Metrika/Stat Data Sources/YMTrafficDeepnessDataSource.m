//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMTrafficDeepnessDataSource.h"
#import "YMTrafficDeepness.h"

typedef enum {
    YMTrafficDeepnessTypeVisits = 0,
    YMTrafficDeepnessTypeDenial,
    YMTrafficDeepnessTypeDepth,
    YMTrafficDeepnessTypeVisitTime,
} YMTrafficDeepnessType;

@implementation YMTrafficDeepnessDataSource

- (YMTrafficDeepnessDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        self.data = [content sortedArrayUsingComparator:^NSComparisonResult(YMTrafficDeepness *obj1, YMTrafficDeepness *obj2) {
            float visits1 = obj1.visits.floatValue;
            float visits2 = obj2.visits.floatValue;
            if (visits1 > visits2)
                return NSOrderedAscending;
            else if (visits1 < visits2)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
    }

    return self;
}

- (NSArray *)typeTitles {
    static NSArray *titles;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        titles = @[
                NSLocalizedString(@"Picker-Visits", nil),
                NSLocalizedString(@"Picker-Failure", nil),
                NSLocalizedString(@"Picker-Deepness", nil),
                NSLocalizedString(@"Picker-Time", nil)
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMTrafficDeepness *summary = data;
    if (index == YMTrafficDeepnessTypeVisits) {
        return summary.visits;
    } else if (index == YMTrafficDeepnessTypeDenial) {
        return summary.denial;
    } else if (index == YMTrafficDeepnessTypeDepth) {
        return summary.depth;
    } else if (index == YMTrafficDeepnessTypeVisitTime) {
        return summary.visitTime;
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMTrafficDeepness *) data name];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMTrafficDeepness *) data visits].floatValue;
}

-(BOOL)isIndexForPercentValue:(NSUInteger)index {
    return (index == YMTrafficDeepnessTypeDenial);
}

-(BOOL)isIndexForTimeValue:(NSUInteger)index {
    return index == YMTrafficDeepnessTypeVisitTime;
}

-(BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return (index == YMTrafficDeepnessTypeDenial || index == YMTrafficDeepnessTypeVisitTime || index == YMTrafficDeepnessTypeDepth);
}

-(NSUInteger)indexOfValueForCalculateAverage {
    return YMTrafficDeepnessTypeVisits;
}

//- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex {
//    if (typeIndex == YMTrafficDeepnessTypeDepth) {
//        return [self totalValueForIndex:YMTrafficDeepnessTypePercent] / [self totalValueForIndex:YMTrafficDeepnessTypeVisits];
//    } else {
//        return [super totalValueForIndex:typeIndex];
//    }
//}

@end