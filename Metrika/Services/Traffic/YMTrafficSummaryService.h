//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTrafficSummaryWrapper;


@interface YMTrafficSummaryService : YMAbstractService

- (void)getSummaryForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (NSArray *content))success failure:(YMServiceErrorBlock)failure;

@end