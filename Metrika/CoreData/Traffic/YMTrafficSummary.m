//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Objection/Objection.h>
#import "YMTrafficSummary.h"
#import "RKEntityMapping.h"
#import "NSManagedObject+YMAdditions.h"
#import "YMUtils.h"

@implementation YMTrafficSummary

@dynamic date;
@dynamic visits;
@dynamic pageViews;
@dynamic visitors;
@dynamic visitorsNew;
@dynamic denial;
@dynamic depth;
@dynamic visitTime;
@dynamic token;
@dynamic lang;
@dynamic parentId;

+ (RKEntityMapping *)mapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    [mapping addAttributeMappingsFromDictionary:@{
            @"date" : @"date",
            @"visits" : @"visits",
            @"page_views" : @"pageViews",
            @"visitors" : @"visitors",
            @"new_visitors" : @"visitorsNew",
            @"denial" : @"denial",
            @"depth" : @"depth",
            @"visit_time" : @"visitTime",
            @"@parent.id" : @"parentId",
            @"@parent.token" : @"token",
            @"@parent.lang" : @"lang"
    }];
    mapping.identificationAttributes = @[@"date", @"parentId", @"token", @"lang"];
    return mapping;
}

+ (NSArray *)allFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate counter:(NSNumber *)counter token:(NSString *)token {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (token = %@) AND (parentId = %@) AND (lang = %@)",
                    fromDate, toDate, token, counter, [YMUtils isPreferredRussianLanguage] ? kRussianLang : kEnglishLang];
    return [self allByPredicate:predicate];
}

@end