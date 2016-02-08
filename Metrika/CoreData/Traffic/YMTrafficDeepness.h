//
// Created by Dmitry Korotchenkov on 29.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"
#import "YMTrafficDeepnessWrapper.h"
#import "YMAbstractChildEntity.h"


@interface YMTrafficDeepness : YMAbstractChildEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *visits;
@property (nonatomic, strong) NSNumber *percent;

@property (nonatomic, strong) NSNumber *denial;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *visitTime;

@end