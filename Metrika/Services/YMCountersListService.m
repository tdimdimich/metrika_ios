//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMCountersListService.h"
#import "YMCountersListWrapper.h"

static NSString *kGetCounters = @"/counters";

@implementation YMCountersListService

- (void)getCountersWithToken:(NSString *)token
                successBlock:(void (^) (YMCountersListWrapper *content))successBlock
                failureBlock:(YMServiceErrorBlock)failureBlock
               progressBlock:(YMDownloadProgressBlock)downloadBlock {
    static dispatch_once_t t = 0;
    dispatch_once(&t, ^{
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMCountersListWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kGetCounters stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];


        [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    });

    [self sendRequest:kGetCounters
           parameters:@{
                   kTokenParamKey : token,
                   @"pretty" : @1
           } success:successBlock failure:failureBlock downloadProgressBlock:downloadBlock];
}

@end