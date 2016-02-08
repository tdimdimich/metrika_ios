//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"


@interface YMAbstractWrapper : YMAbstractEntity

@property (nonatomic, strong) NSNumber *counter;
@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *dateEnd;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lang;

+ (RKEntityMapping *)mapping;

+ (id)objectFromCoreDataForCounter:(NSNumber *)counter fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate token:(NSString *)token;

@end