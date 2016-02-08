//
// Created by Dmitry Korotchenkov on 14/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentPopularDataSource.h"
#import "YMContentPopular.h"
#import "YMContentPopularWrapper.h"

typedef enum {
    YMContentPopularTypePageViews = 0,
    YMContentPopularTypeEntrance,
    YMContentPopularTypeExit,
} YMContentPopularType;

@implementation YMContentPopularDataSource

- (YMContentPopularDataSource *)initWithContent:(YMContentPopularWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        self.data = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMContentPopular *obj1, YMContentPopular *obj2) {
            float visits1 = obj1.pageViews.floatValue;
            float visits2 = obj2.pageViews.floatValue;
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
                NSLocalizedString(@"Picker-Views", @"Другие"),
                NSLocalizedString(@"Picker-EntryPages", nil),
                NSLocalizedString(@"Picker-ExitPages", nil)
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMContentPopular *summary = data;
    if (index == YMContentPopularTypePageViews) {
        return summary.pageViews;
    } else if (index == YMContentPopularTypeEntrance) {
        return summary.entrance;
    } else if (index == YMContentPopularTypeExit) {
        return summary.exit;
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMContentPopular *) data urlFull];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMContentPopular *) data pageViews].floatValue;
}

- (BOOL)isIndexForPercentValue:(NSUInteger)index {
    return NO;
}

- (BOOL)isIndexForTimeValue:(NSUInteger)index {
    return NO;
}

- (BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return NO;
}

- (NSUInteger)indexOfValueForCalculateAverage {
    return YMContentPopularTypePageViews;
}

@end