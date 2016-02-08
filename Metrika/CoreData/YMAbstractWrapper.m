//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import "YMAbstractWrapper.h"
#import "NSManagedObject+YMAdditions.h"
#import "YMUtils.h"


@implementation YMAbstractWrapper

@dynamic counter;
@dynamic dateStart;
@dynamic dateEnd;
@dynamic token;
@dynamic lang;

+ (RKEntityMapping *)mapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id":@"counter",
            @"date1":@"dateStart",
            @"date2":@"dateEnd",
            @"token":@"token",
            @"lang":@"lang"
    }];

    mapping.identificationAttributes = @[@"counter",@"token", @"lang",@"dateEnd",@"dateStart"];
    return mapping;
}

+ (id)objectFromCoreDataForCounter:(NSNumber *)counter fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate token:(NSString *)token {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(counter = %@) AND (dateStart = %@) AND (dateEnd = %@) AND (token = %@) AND (lang = %@)",
                    counter, fromDate, toDate, token, [YMUtils isPreferredRussianLanguage] ? kRussianLang : kEnglishLang];
    return [self allByPredicate:predicate].lastObject;
}

@end