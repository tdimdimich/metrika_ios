//
// Created by Dmitry Korotchenkov on 13/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "YMDemographyStructureDataSource.h"
#import "YMDemographyStructureWrapper.h"
#import "YMDemographyStructure.h"
#import "YMValueTypeStringFormat.h"
#import "YMDetailedElementModel.h"

typedef enum {
    YMDemographyStructureTypeVisits = 0,
    YMDemographyStructureTypeVisitsPercent,
    YMDemographyStructureTypeDenial,
    YMDemographyStructureTypeDepth,
    YMDemographyStructureTypeVisitTime,
} YMDemographyStructureType;

@implementation YMDemographyStructureDataSource

- (YMDemographyStructureDataSource *)initWithContent:(YMDemographyStructureWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        self.data = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMDemographyStructure *obj1, YMDemographyStructure *obj2) {
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
                NSLocalizedString(@"Picker-ShareOfVisits", @"Доля визитов"),
                NSLocalizedString(@"Picker-Failure", nil),
                NSLocalizedString(@"Picker-Deepness", nil),
                NSLocalizedString(@"Picker-Time", nil),
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMDemographyStructure *summary = data;
    if (index == YMDemographyStructureTypeVisits) {
        return summary.visits;
    } else if (index == YMDemographyStructureTypeVisitsPercent) {
        return summary.visitsPercent;
    } else if (index == YMDemographyStructureTypeDenial) {
        return summary.denial;
    } else if (index == YMDemographyStructureTypeDepth) {
        return summary.depth;
    } else if (index == YMDemographyStructureTypeVisitTime) {
        return summary.visitTime;
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [NSString stringWithFormat:@"%@, %@", [(YMDemographyStructure *) data gender].capitalizedString, [(YMDemographyStructure *) data name]];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMDemographyStructure *) data visits].floatValue;
}

-(BOOL)isIndexForPercentValue:(NSUInteger)index {
    return (index == YMDemographyStructureTypeDenial || index == YMDemographyStructureTypeVisitsPercent);
}

-(BOOL)isIndexForTimeValue:(NSUInteger)index {
    return index == YMDemographyStructureTypeVisitTime;
}

-(BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return (index == YMDemographyStructureTypeDenial || index == YMDemographyStructureTypeVisitTime || index == YMDemographyStructureTypeDepth);
}

-(NSUInteger)indexOfValueForCalculateAverage {
    return YMDemographyStructureTypeVisits;
}

- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex {
    if (typeIndex == YMDemographyStructureTypeDepth) {
        return [super totalValueForIndex:typeIndex] / self.data.count;
    } else {
        return [super totalValueForIndex:typeIndex];
    }
}

@end