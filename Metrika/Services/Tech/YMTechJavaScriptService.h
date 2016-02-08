//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMTechJavaScriptWrapper;


@interface YMTechJavaScriptService : YMAbstractService
- (void)getJavaScriptForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTechJavaScriptWrapper *content))success failure:(YMServiceErrorBlock)failure;
@end