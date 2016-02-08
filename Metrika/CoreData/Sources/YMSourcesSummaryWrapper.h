//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"
#import "YMAbstractWrapper.h"


@interface YMSourcesSummaryWrapper : YMAbstractWrapper

@property (nonatomic, strong) NSSet *data;

@end