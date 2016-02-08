//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTrafficHourlyWrapper;


@interface YMTrafficHourlyService : YMAbstractService
- (void)getHourlyForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTrafficHourlyWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end