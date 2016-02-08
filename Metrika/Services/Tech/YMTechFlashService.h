//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTechFlashWrapper;


@interface YMTechFlashService : YMAbstractService
- (void)getFlashForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTechFlashWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end