//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMTrafficHourlyService.h"
#import "YMTrafficHourlyWrapper.h"
#import "NSDate+YMAdditions.h"
#import "NSManagedObject+YMAdditions.h"

static NSString *kApiPath = @"/stat/traffic/hourly";

@implementation YMTrafficHourlyService

- (void)getHourlyForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMTrafficHourlyWrapper *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMTrafficHourlyWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMTrafficHourlyWrapper *hourlyWrapper = [YMTrafficHourlyWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];

    if (!hourlyWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey : token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat]
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMTrafficHourlyWrapper *content) {
                      content.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          content.dateEnd = [NSDate dateWithTimeIntervalSince1970:15];
                      } else {
                          content.dateEnd = [toDate beginOfDay];
                      }
                      [[YMTrafficHourlyWrapper getContext] saveToPersistentStore:nil];
                      success(content);
                  }

                failure:failure];
    } else {
        success(hourlyWrapper);
    }
}

@end