//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractWrapper.h"
#import "YMAbstractService.h"

@class YMTechOSWrapper;


@interface YMTechOSService : YMAbstractService

- (void)getOSForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTechOSWrapper *content))success failure:(YMServiceErrorBlock)failure;

@end