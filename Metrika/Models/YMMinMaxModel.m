//
// Created by Dmitry Korotchenkov on 20/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMMinMaxModel.h"
#import "YMUtils.h"
#import "YMValueTypeStringFormat.h"


@implementation YMMinMaxModel

- (instancetype)initWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    self = [super init];
    if (self) {
        self.minDate = minDate;
        self.maxDate = maxDate;
        self.minValue = minValue;
        self.maxValue = maxValue;
    }

    return self;
}

+ (instancetype)modelWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    return [[self alloc] initWithMinDate:minDate maxDate:maxDate minValue:minValue maxValue:maxValue];
}

- (NSString *)maxValueString {
    if (!_maxValueString) {
        return [YMValueTypeStringFormat formatFromFloatValue:self.maxValue].combinedString;
    } else
        return _maxValueString;
}

- (NSString *)minValueString {
    if (!_minValueString) {
        return [YMValueTypeStringFormat formatFromFloatValue:self.minValue].combinedString;
    } else
        return _minValueString;
}


@end