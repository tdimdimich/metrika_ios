//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMContentPopularWrapper;


@interface YMContentPopularService : YMAbstractService

- (void)getPopularForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMContentPopularWrapper *content))success failure:(YMServiceErrorBlock)failure;

@end