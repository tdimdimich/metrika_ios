//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"


@interface YMCountersListWrapper : YMAbstractEntity

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSSet *counters;

+ (RKEntityMapping *)mapping;

@end