//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMContentExitWrapper;


@interface YMContentExitService : YMAbstractService
- (void)getExitForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMContentExitWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end