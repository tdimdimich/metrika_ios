//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMStandardStatDataSource.h"
#import "YMTechMobileWrapper.h"
#import "YMTechMobile.h"
#import "YMObjectForGrouping.h"
#import "YMStandardStatObject.h"

typedef enum {
    YMObjectTypeVisits,
    YMObjectTypePageViews,
    YMObjectTypeDenial,
    YMObjectTypeDepth,
    YMObjectTypeVisitTime,
} YMObjectType;

@interface YMStandardStatDataSource ()
@property(nonatomic, strong) NSMutableArray *portraitData;
@property(nonatomic, strong) NSMutableArray *landscapeData;
@property(nonatomic) BOOL needGrouping;
@end

@implementation YMStandardStatDataSource

- (YMStandardStatDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd needGrouping:(BOOL)needGrouping {
    self = [super init];
    if (self) {
        self.needGrouping = needGrouping;
        NSArray *sortedData = [content sortedArrayUsingComparator:^NSComparisonResult(NSObject <YMStandardStatObject> *obj1, NSObject <YMStandardStatObject> *obj2) {
            float visits1 = obj1.visits.floatValue;
            float visits2 = obj2.visits.floatValue;
            if (visits1 > visits2)
                return NSOrderedAscending;
            else if (visits1 < visits2)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];

        NSMutableArray *landscapeData = [NSMutableArray new];
        NSMutableArray *portraitData = [NSMutableArray new];
        for (NSUInteger i = 0; i < sortedData.count; i++) {
            NSObject <YMStandardStatObject> *object = sortedData[i];
            [landscapeData addObject:[[YMObjectForGrouping alloc] initWithName:object.mainValue
                                                                        visits:object.visits.floatValue
                                                                     pageViews:object.pageViews.floatValue
                                                                        denial:object.denial.floatValue
                                                                     visitTime:object.visitTime.floatValue]];
            if (needGrouping) {
                if (i <= 12) {
                    NSString *name = i == 12 ? NSLocalizedString(@"Others", @"Другие") : object.mainValue;
                    [portraitData addObject:[[YMObjectForGrouping alloc] initWithName:name
                                                                               visits:object.visits.floatValue
                                                                            pageViews:object.pageViews.floatValue
                                                                               denial:object.denial.floatValue
                                                                            visitTime:object.visitTime.floatValue]];
                } else {
                    YMObjectForGrouping *sitesObject = portraitData[12];
                    [sitesObject addVisits:object.visits.floatValue
                                 pageViews:object.pageViews.floatValue
                                    denial:object.denial.floatValue
                                 visitTime:object.visitTime.floatValue];
                }
            }
        }

        self.portraitData = portraitData;
        self.landscapeData = landscapeData;
        self.data = landscapeData;
    }

    return self;
}

- (void)addDataWithName:(NSString *)name visits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime {
    [self.landscapeData addObject:[[YMObjectForGrouping alloc] initWithName:name
                                                                visits:visits
                                                             pageViews:pageViews
                                                                denial:denial
                                                             visitTime:visitTime]];
    if (self.needGrouping) {
        if (self.landscapeData.count <= 12) {
            [self.portraitData addObject:[[YMObjectForGrouping alloc] initWithName:name
                                                                             visits:visits
                                                                          pageViews:pageViews
                                                                             denial:denial
                                                                          visitTime:visitTime]];
        } else {
            YMObjectForGrouping *sitesObject = self.portraitData[12];
            [sitesObject addVisits:visits
                         pageViews:pageViews
                            denial:denial
                         visitTime:visitTime];
        }
    }
}

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode {
    if (self.needGrouping) {
        self.data = isLandscapeMode ? self.landscapeData : self.portraitData;
    } else {
        self.data = self.landscapeData;
    }
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
                NSLocalizedString(@"Picker-Time", nil)
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMObjectForGrouping *displayObject = data;
    if (index == YMObjectTypeVisits) {
        return [NSNumber numberWithFloat:displayObject.visits];
    } else if (index == YMObjectTypePageViews) {
        return [NSNumber numberWithFloat:displayObject.pageViews];
    } else if (index == YMObjectTypeDenial) {
        return [NSNumber numberWithFloat:displayObject.denial];
    } else if (index == YMObjectTypeDepth) {
        return [NSNumber numberWithFloat:displayObject.depth];
    } else if (index == YMObjectTypeVisitTime) {
        return [NSNumber numberWithFloat:displayObject.visitTime];
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMObjectForGrouping *) data name];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMObjectForGrouping *) data visits];
}

- (BOOL)isIndexForPercentValue:(NSUInteger)index {
    return (index == YMObjectTypeDenial);
}

- (BOOL)isIndexForTimeValue:(NSUInteger)index {
    return index == YMObjectTypeVisitTime;
}

- (BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return (index == YMObjectTypeDenial || index == YMObjectTypeVisitTime || index == YMObjectTypeDepth);
}

- (NSUInteger)indexOfValueForCalculateAverage {
    return YMObjectTypeVisits;
}

- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex {
    if (typeIndex == YMObjectTypeDepth) {
        return [self totalValueForIndex:YMObjectTypePageViews] / [self totalValueForIndex:YMObjectTypeVisits];
    } else {
        return [super totalValueForIndex:typeIndex];
    }
}

@end