//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMDateRange : NSObject

@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *dateEnd;

- (instancetype)initWithDateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

- (NSUInteger)lengthIdDays;

+ (instancetype)rangeWithDateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

@end