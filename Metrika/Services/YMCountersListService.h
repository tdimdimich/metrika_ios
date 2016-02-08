//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractService.h"

@class YMCountersListWrapper;


@interface YMCountersListService : YMAbstractService

- (void)getCountersWithToken:(NSString *)token successBlock:(void (^) (YMCountersListWrapper *content))successBlock
                failureBlock:(YMServiceErrorBlock)failureBlock progressBlock:(YMDownloadProgressBlock)downloadBlock;

@end