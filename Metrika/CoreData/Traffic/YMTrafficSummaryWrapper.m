//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMTrafficSummaryWrapper.h"
#import "RKEntityMapping.h"
#import "YMTrafficSummary.h"
#import "NSManagedObject+YMAdditions.h"
#import "YMUtils.h"


@implementation YMTrafficSummaryWrapper

@dynamic data;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[YMTrafficSummary mapping]];

    return mapping;
}

+ (id)objectFromCoreDataForCounter:(NSNumber *)counter fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate token:(NSString *)token {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(counter = %@) AND (dateStart <= %@) AND (dateEnd => %@) AND (token = %@) AND (lang = %@)",
                    counter, fromDate, toDate, token, [YMUtils isPreferredRussianLanguage] ? kRussianLang : kEnglishLang];
    return [self allByPredicate:predicate].lastObject;
}

@end