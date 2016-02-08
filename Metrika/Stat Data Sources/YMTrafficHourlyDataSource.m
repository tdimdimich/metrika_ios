//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMTrafficHourlyDataSource.h"
#import "YMTrafficHourlyWrapper.h"
#import "YMTrafficHourly.h"
#import "NSDate+DKAdditions.h"
#import "NSDate+YMAdditions.h"

typedef enum {
    YMTrafficHourlyTypeAvgVisits = 0,
    YMTrafficHourlyTypeDenial,
    YMTrafficHourlyTypeDepth,
    YMTrafficHourlyTypeVisitTime,
} YMTrafficHourlyType;

@interface YMTrafficHourlyObject : NSObject

@property(nonatomic, strong) NSString *name;

@property(nonatomic) float avgVisitSum;
@property(nonatomic) float denialSum;
@property(nonatomic) float depthSum;
@property(nonatomic) float visitTimeSum;
@property(nonatomic) float count;

@end

@implementation YMTrafficHourlyObject

- (id)initWithTrafficHourly:(NSArray *)trafficHourly name:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.avgVisitSum = 0;
        self.depthSum = 0;
        self.denialSum = 0;
        self.visitTimeSum = 0;
        for (YMTrafficHourly *traffic in trafficHourly) {
            self.avgVisitSum += traffic.avgVisit.floatValue;
            self.denialSum += traffic.denial.floatValue * traffic.avgVisit.floatValue;
            self.depthSum += traffic.depth.floatValue * traffic.avgVisit.floatValue;
            self.visitTimeSum += traffic.visitTime.floatValue * traffic.avgVisit.floatValue;
        }
        self.count = trafficHourly.count;
    }

    return self;
}

- (float)depth {
    return self.denialSum / self.avgVisitSum;
}

- (float)visitTime {
    return self.visitTimeSum / self.avgVisitSum;
}

- (float)denial {
    return self.denialSum / self.avgVisitSum;
}

- (float)avgVisits {
    return self.denialSum / self.count;
}

@end

@interface YMTrafficHourlyDataSource ()
@property(nonatomic, strong) NSMutableArray *portraitData;
@property(nonatomic, strong) NSMutableArray *landscapeData;
@end

@implementation YMTrafficHourlyDataSource

- (YMTrafficHourlyDataSource *)initWithContent:(YMTrafficHourlyWrapper *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        NSArray *sortedData = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMTrafficHourly *obj1, YMTrafficHourly *obj2) {
            return [obj1.hours compare:obj2.hours];
        }];

        NSMutableArray *portraitData = [NSMutableArray new];
        static NSTimeZone *timeZone = nil;
        if (!timeZone) {
            timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        }
        NSMutableArray *landscapeData = [NSMutableArray new];
        for (NSUInteger i = 0; i < sortedData.count / 2; i++) {
            YMTrafficHourly *firstObject = sortedData[i * 2];
            YMTrafficHourly *secondObject = sortedData[i * 2 + 1];
            [landscapeData addObject:[[YMTrafficHourlyObject alloc] initWithTrafficHourly:@[firstObject] name:[firstObject.hours stringWithFormat:@"HH:mm" inTimeZone:timeZone]]];
            [landscapeData addObject:[[YMTrafficHourlyObject alloc] initWithTrafficHourly:@[secondObject] name:[secondObject.hours stringWithFormat:@"HH:mm" inTimeZone:timeZone]]];
            NSString *dateString = [NSString stringWithFormat:@"%@ - %@", [firstObject.hours stringWithFormat:@"HH:mm" inTimeZone:timeZone],
                                                              [[secondObject.hours dateByAddingTimeInterval:3600] stringWithFormat:@"HH:mm" inTimeZone:timeZone]];
            [portraitData addObject:[[YMTrafficHourlyObject alloc] initWithTrafficHourly:@[firstObject, secondObject]
                                                                                    name:dateString]];
        }

        self.portraitData = portraitData;
        self.landscapeData = landscapeData;
        self.data = portraitData;
    }

    return self;
}

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode {
    self.data = isLandscapeMode ? self.landscapeData : self.portraitData;
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
    YMTrafficHourlyObject *summary = data;
    if (index == YMTrafficHourlyTypeAvgVisits) {
        return [NSNumber numberWithFloat:summary.avgVisits];
    } else if (index == YMTrafficHourlyTypeDenial) {
        return [NSNumber numberWithFloat:summary.denial];
    } else if (index == YMTrafficHourlyTypeDepth) {
        return [NSNumber numberWithFloat:summary.depth];
    } else if (index == YMTrafficHourlyTypeVisitTime) {
        return [NSNumber numberWithFloat:summary.visitTime];
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMTrafficHourlyObject *) data name];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMTrafficHourlyObject *) data avgVisits];
}

- (BOOL)isIndexForPercentValue:(NSUInteger)index {
    return (index == YMTrafficHourlyTypeDenial);
}

- (BOOL)isIndexForTimeValue:(NSUInteger)index {
    return index == YMTrafficHourlyTypeVisitTime;
}

- (BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    return (index == YMTrafficHourlyTypeDenial || index == YMTrafficHourlyTypeVisitTime || index == YMTrafficHourlyTypeDepth);
}

- (NSUInteger)indexOfValueForCalculateAverage {
    return YMTrafficHourlyTypeAvgVisits;
}

@end