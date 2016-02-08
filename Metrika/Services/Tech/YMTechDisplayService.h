//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTechDisplayWrapper;


@interface YMTechDisplayService : YMAbstractService
- (void)getDisplaysForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTechDisplayWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end