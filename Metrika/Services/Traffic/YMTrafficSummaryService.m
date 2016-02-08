//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Objection/Objection.h>
#import "YMTrafficSummaryService.h"
#import "YMTrafficSummaryWrapper.h"
#import "YMTrafficSummary.h"
#import "NSDate+YMAdditions.h"
#import "YMUtils.h"
#import "NSManagedObject+YMAdditions.h"
#import "NSArray+BlocksKit.h"

static NSString *kApiPath = @"/stat/traffic/summary";

@implementation YMTrafficSummaryService

objection_register(YMTrafficSummaryService)

- (void)getSummaryForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (NSArray *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMTrafficSummaryWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMTrafficSummaryWrapper *trafficWrapper = [YMTrafficSummaryWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];
    if (!trafficWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey : token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat],
                @"per_page" : @"10000"
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMTrafficSummaryWrapper *traffic) {
                      traffic.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          traffic.dateEnd = [[[NSDate date] beginOfDay] dateByAddingDays:-1];
                      } else {
                          traffic.dateEnd = [toDate beginOfDay];
                      }
                      [[YMTrafficSummaryWrapper getContext] saveToPersistentStore:nil];
//                      success(traffic.data.allObjects);
                      // Яндекс не обязательно присылает данные находящиеся в заданом диапазоне наблюдается например в
                      // следующем запросе: http://api-metrika.yandex.ru/stat/traffic/summary.json?date1=20110517&date2=20120519&id=20146120&oauth_token=a602677e128047b3bf427f777739d334&per_page=10000
                      success([YMTrafficSummary allFromDate:fromDate toDate:toDate counter:counter token:token]);
                  }
                  failure:failure];
    } else {
        success([YMTrafficSummary allFromDate:fromDate toDate:toDate counter:counter token:token]);
    }
}

@end