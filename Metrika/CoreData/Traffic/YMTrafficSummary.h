//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"

@class RKObjectMapping;
@class YMTrafficSummaryWrapper;


@interface YMTrafficSummary : NSManagedObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *visits;
@property (nonatomic, strong) NSNumber *pageViews;
@property (nonatomic, strong) NSNumber *visitors;
@property (nonatomic, strong) NSNumber *visitorsNew;
@property (nonatomic, strong) NSNumber *denial;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *visitTime;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lang;

@property (nonatomic, strong) NSNumber *parentId;

+ (RKEntityMapping *)mapping;

//+ (NSArray *)allFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate counter:(NSNumber *)counter;

+ (NSArray *)allFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate counter:(NSNumber *)counter token:(NSString *)token;
@end