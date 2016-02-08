//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMColGroup.h"
#import "YMPlotPoint.h"

@interface YMColGroup ()

@property(nonatomic, strong) NSNumber *maximumYValue;

@end

@implementation YMColGroup

- (id)initWithGroupXValue:(CGFloat)groupXValue groupValues:(NSArray *)groupValues {
    self = [super init];
    if (self) {
        self.groupXValue = groupXValue;
        self.groupValues = groupValues;
    }

    return self;
}

+ (id)groupWithGroupXValue:(CGFloat)groupXValue groupValues:(NSArray *)groupValues {
    return [[self alloc] initWithGroupXValue:groupXValue groupValues:groupValues];
}


- (CGFloat)maxYValue {
    if (!self.maximumYValue) {
        CGFloat value = 0;
        for (NSNumber *number in self.groupValues) {
            if (number.floatValue > value) {
                value = number.floatValue;
            }
        }
        self.maximumYValue = [NSNumber numberWithFloat:value];
    }
    return [self.maximumYValue floatValue];
}

@end