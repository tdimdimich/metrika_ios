//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMSourcesSearchEnginesService.h"
#import "YMSourcesSearchEnginesWrapper.h"
#import "NSDate+YMAdditions.h"
#import "NSManagedObject+YMAdditions.h"

static NSString *kApiPath = @"/stat/sources/search_engines";

@implementation YMSourcesSearchEnginesService

- (void)getSearchEnginesForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMSourcesSearchEnginesWrapper *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMSourcesSearchEnginesWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMSourcesSearchEnginesWrapper *searchEnginesWrapper = [YMSourcesSearchEnginesWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];

    if (!searchEnginesWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey : token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat]
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMSourcesSearchEnginesWrapper *content) {
                      content.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          content.dateEnd = [NSDate dateWithTimeIntervalSince1970:15];
                      } else {
                          content.dateEnd = [toDate beginOfDay];
                      }
                      [[YMSourcesSearchEnginesWrapper getContext] saveToPersistentStore:nil];
                      success(content);
                  }

                failure:failure];
    } else {
        success(searchEnginesWrapper);
    }
}

@end