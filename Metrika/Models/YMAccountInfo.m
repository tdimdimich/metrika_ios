//
// File: YMAccountInfo.m
// Project: Metrika
//
// Created by dkorneev on 8/29/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMAccountInfo.h"
#import "YMCounterInfo.h"


@implementation YMAccountInfo

@dynamic name;
@dynamic token;
@dynamic lang;
@dynamic counterInfo;
@dynamic hidden;
@dynamic shouldBeRemoved;

- (NSArray *)visibleCountersInfo {
    return [self.counterInfo.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(YMCounterInfo *evaluatedObject, NSDictionary *bindings) {
        return !evaluatedObject.hidden;
    }]];
}

@end