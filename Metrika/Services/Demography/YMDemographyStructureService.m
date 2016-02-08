//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMDemographyStructureService.h"
#import "YMDemographyStructureWrapper.h"
#import "NSDate+YMAdditions.h"
#import "NSManagedObject+YMAdditions.h"

static NSString *kApiPath = @"/stat/demography/structure";

@implementation YMDemographyStructureService

- (void)getDemographyForCounter:(NSNumber *)counter token:(NSString *)token fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(void (^) (YMDemographyStructureWrapper *content))success failure:(YMServiceErrorBlock)failure {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[YMDemographyStructureWrapper mapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:[kApiPath stringByAppendingString:@"\\.json"]
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor];
    });

    YMDemographyStructureWrapper *demographyWrapper = [YMDemographyStructureWrapper objectFromCoreDataForCounter:counter fromDate:fromDate toDate:toDate token:token];

    if (!demographyWrapper) {
        NSDictionary *params = @{@"id" : counter,
                kTokenParamKey : token,
                @"date1" : [fromDate stringInddMMyyyyFormat],
                @"date2" : [toDate stringInddMMyyyyFormat]
        };
        [self sendRequest:kApiPath
               parameters:params
                  success:^(YMDemographyStructureWrapper *content) {
                      content.dateStart = [fromDate beginOfDay];
                      if ([toDate isMoreThanOrEqual:[[NSDate date] beginOfDay]]) {
                          content.dateEnd = [NSDate dateWithTimeIntervalSince1970:15];
                      } else {
                          content.dateEnd = [toDate beginOfDay];
                      }
                      [[YMDemographyStructureWrapper getContext] saveToPersistentStore:nil];
                      success(content);
                  }
                  failure:failure];
    } else {
        success(demographyWrapper);
    }
}

@end