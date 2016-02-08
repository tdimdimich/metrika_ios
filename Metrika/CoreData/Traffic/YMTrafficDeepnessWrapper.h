//
// Created by Dmitry Korotchenkov on 29.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"
#import "YMAbstractWrapper.h"

@class YMTrafficDeepness;

@interface YMTrafficDeepnessWrapper : YMAbstractWrapper

@property (nonatomic, strong) NSSet *dataDepth;
@property (nonatomic, strong) NSSet *dataTime;

@end