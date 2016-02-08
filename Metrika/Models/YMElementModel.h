//
// Created by Dmitry Korotchenkov on 16/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMMinMaxModel.h"


@interface YMElementModel : YMMinMaxModel

@property (nonatomic) CGFloat totalValue;
@property (nonatomic, strong) NSString *totalString;
@property (nonatomic, strong) NSString *totalType;

- (YMElementModel *)initWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate totalValue:(CGFloat)totalValue minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

+ (YMElementModel *)modelWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate totalValue:(CGFloat)totalValue minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end