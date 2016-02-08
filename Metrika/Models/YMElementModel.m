//
// Created by Dmitry Korotchenkov on 16/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMElementModel.h"
#import "YMUtils.h"
#import "YMValueTypeStringFormat.h"

@implementation YMElementModel

- (YMElementModel *)initWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate totalValue:(CGFloat)totalValue minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    self = [super initWithMinDate:minDate maxDate:maxDate minValue:minValue maxValue:maxValue];
    if (self) {
        self.totalValue = totalValue;
    }

    return self;
}

+ (YMElementModel *)modelWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate totalValue:(CGFloat)totalValue minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    return [[self alloc] initWithMinDate:minDate maxDate:maxDate totalValue:totalValue minValue:minValue maxValue:maxValue];
}


- (NSString *)totalString {
    if (!_totalString) {
        return [YMValueTypeStringFormat formatFromFloatValue:self.totalValue].combinedString;
    } else
        return _totalString;
}


@end