//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMContentUrlWrapper;


@interface YMContentUrlService : YMAbstractService
- (void)getUrlForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMContentUrlWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end