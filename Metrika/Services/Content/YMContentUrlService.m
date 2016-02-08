//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMContentUrlService.h"
#import "YMContentUrlWrapper.h"
#import "NSDate+YMAdditions.h"
#import "NSManagedObject+YMAdditions.h"

static NSString *kApiPath = @"/stat/content/url_param";

@implementation YMContentUrlService

- (void)getUrlForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMContentUrlWrapper *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMContentUrlWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMContentUrlWrapper *sitesWrapper = [YMContentUrlWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];

    if (!sitesWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey : token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat],
                @"table_mode" : @"tree"
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMContentUrlWrapper *content) {
                      content.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          content.dateEnd = [NSDate dateWithTimeIntervalSince1970:15];
                      } else {
                          content.dateEnd = [toDate beginOfDay];
                      }
                      [[YMContentUrlWrapper getContext] saveToPersistentStore:nil];
                      success(content);
                  }

                  failure:failure];
    } else {
        success(sitesWrapper);
    }
}

@end