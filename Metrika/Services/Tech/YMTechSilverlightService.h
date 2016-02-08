//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTechSilverlightWrapper;


@interface YMTechSilverlightService : YMAbstractService
- (void)getSilverlightForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTechSilverlightWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end