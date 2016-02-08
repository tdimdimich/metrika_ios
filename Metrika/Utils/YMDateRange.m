//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMDateRange.h"
#import "NSDate+YMAdditions.h"


@implementation YMDateRange
- (instancetype)initWithDateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {
        self.dateStart = dateStart;
        self.dateEnd = dateEnd;
    }

    return self;
}

+ (instancetype)rangeWithDateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    return [[self alloc] initWithDateStart:dateStart dateEnd:dateEnd];
}

- (NSUInteger)lengthIdDays {
    return (NSUInteger) ([self.dateStart daysToDate:self.dateEnd] + 1);
}

@end