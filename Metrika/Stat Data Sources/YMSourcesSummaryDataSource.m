//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import "YMSourcesSummaryDataSource.h"
#import "YMSourcesSummaryWrapper.h"
#import "YMSourcesSummary.h"

typedef enum {
    YMSourcesSummaryTypeVisits = 0,
    YMSourcesSummaryTypePageViews,
    YMSourcesSummaryTypeDenial,
    YMSourcesSummaryTypeDepth,
    YMSourcesSummaryTypeVisitTime,
    YMSourcesSummaryTypeVisitDelayed,
} YMSourcesSummaryType;

@implementation YMSourcesSummaryDataSource

- (YMSourcesSummaryDataSource *)initWithContent:(YMSourcesSummaryWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        self.data = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMSourcesSummary *obj1, YMSourcesSummary *obj2) {
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
                NSLocalizedString(@"Picker-Views", nil),
                NSLocalizedString(@"Picker-Failure", nil),
                NSLocalizedString(@"Picker-Deepness", nil),
                NSLocalizedString(@"Picker-Time", nil),
                NSLocalizedString(@"Picker-Returning", nil),
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMSourcesSummary *summary = data;
    if (index == YMSourcesSummaryTypeVisits) {
        return summary.visits;
    } else if (index == YMSourcesSummaryTypePageViews) {
        return summary.pageViews;
    } else if (index == YMSourcesSummaryTypeDenial) {
        return summary.denial;
    } else if (index == YMSourcesSummaryTypeDepth) {
        return summary.depth;
    } else if (index == YMSourcesSummaryTypeVisitTime) {
        return summary.visitTime;
    } else if (index == YMSourcesSummaryTypeVisitDelayed) {
        return summary.visitsDelayed;
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMSourcesSummary *) data name];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMSourcesSummary *) data visits].floatValue;
}

-(BOOL)isIndexForPercentValue:(NSUInteger)index {
    return index == YMSourcesSummaryTypeDenial;
}

-(BOOL)isIndexForTimeValue:(NSUInteger)index {
    return index == YMSourcesSummaryTypeVisitTime;
}

-(BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return (index == YMSourcesSummaryTypeDenial || index == YMSourcesSummaryTypeVisitTime || index == YMSourcesSummaryTypeDepth);
}

-(NSUInteger)indexOfValueForCalculateAverage {
    return YMSourcesSummaryTypeVisits;
}

- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex {
    if (typeIndex == YMSourcesSummaryTypeDepth) {
        return [self totalValueForIndex:YMSourcesSummaryTypePageViews] / [self totalValueForIndex:YMSourcesSummaryTypeVisits];
    } else {
        return [super totalValueForIndex:typeIndex];
    }
}

@end