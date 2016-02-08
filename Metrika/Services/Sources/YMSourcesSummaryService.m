//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMSourcesSummaryService.h"
#import "YMSourcesSummaryWrapper.h"
#import "NSDate+YMAdditions.h"
#import "NSManagedObject+YMAdditions.h"

static NSString *kApiPath = @"/stat/sources/summary";

@implementation YMSourcesSummaryService

- (void)getSummaryForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMSourcesSummaryWrapper *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMSourcesSummaryWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMSourcesSummaryWrapper *summaryWrapper = [YMSourcesSummaryWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];

    if (!summaryWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey:token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat]
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMSourcesSummaryWrapper *content) {
                      content.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          content.dateEnd = [NSDate dateWithTimeIntervalSince1970:15];
                      } else {
                          content.dateEnd = [toDate beginOfDay];
                      }
                      [[YMSourcesSummaryWrapper getContext] saveToPersistentStore:nil];
                      success(content);
                  }
                  failure:failure];
    } else {
        success(summaryWrapper);
    }
}

@end