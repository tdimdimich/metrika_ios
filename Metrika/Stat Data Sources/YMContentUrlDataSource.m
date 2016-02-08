//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentUrlDataSource.h"
#import "YMContentUrl.h"

typedef enum {
    YMObjectTypePageViews,
} YMObjectType;

@interface YMContentUrlObject : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic) float pageViewsSum;
@property(nonatomic) float count;

@end

@implementation YMContentUrlObject

- (YMContentUrlObject *)initWithUrl:(YMContentUrl *)url name:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.pageViewsSum = url.pageViews.floatValue;
        self.count = 1;
    }
    return self;
}

- (void)addUrl:(YMContentUrl *)url {
    self.pageViewsSum += url.pageViews.floatValue;
    self.count++;
}

-(float)pageViews {
    return self.pageViewsSum / self.count;
}

@end

@interface YMContentUrlDataSource ()
@property(nonatomic, strong) NSMutableArray *portraitData;
@property(nonatomic, strong) NSMutableArray *landscapeData;
@end

@implementation YMContentUrlDataSource

- (YMContentUrlDataSource *)initWithContent:(NSArray *)content dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        NSArray *sortedData = [content sortedArrayUsingComparator:^NSComparisonResult(YMContentUrl *obj1, YMContentUrl *obj2) {
            float visits1 = obj1.pageViews.floatValue;
            float visits2 = obj2.pageViews.floatValue;
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
            YMContentUrl *object = sortedData[i];
            [landscapeData addObject:[[YMContentUrlObject alloc] initWithUrl:object name:object.name]];
            if (i <= 12) {
                NSString *name = i == 12 ? NSLocalizedString(@"Others", @"Другие") : object.name;
                [portraitData addObject:[[YMContentUrlObject alloc] initWithUrl:object name:name]];
            } else {
                YMContentUrlObject *urlObject = portraitData[12];
                [urlObject addUrl:object];
            }
        }

        self.portraitData = portraitData;
        self.landscapeData = landscapeData;
        self.data = landscapeData;
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
                NSLocalizedString(@"Picker-Views", nil)
        ];
    });
    return titles;
}

- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    YMContentUrlObject *displayObject = data;
    if (index == YMObjectTypePageViews) {
        return [NSNumber numberWithFloat:displayObject.pageViews];
    } else {
        return @0;
    }
}

- (NSString *)titleForData:(id)data {
    return [(YMContentUrlObject *) data name];
}

- (CGFloat)mainValueForData:(id)data {
    return [(YMContentUrlObject *) data pageViews];
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
    return YMObjectTypePageViews;
}

@end