//
// Created by Dmitry Korotchenkov on 20/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMMinMaxModel : NSObject

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat maxValue;
@property (nonatomic, strong) NSString *maxValueString;
@property (nonatomic, strong) NSString *minValueString;

- (instancetype)initWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

+ (instancetype)modelWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;


@end