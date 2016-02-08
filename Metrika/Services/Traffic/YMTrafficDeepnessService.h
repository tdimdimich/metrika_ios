//
// Created by Dmitry Korotchenkov on 29.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTrafficDeepnessWrapper;


@interface YMTrafficDeepnessService : YMAbstractService

- (void)getDeepnessForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTrafficDeepnessWrapper *content))success failure:(YMServiceErrorBlock)failure;

@end