//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractEntity.h"
#import "YMAbstractChildEntity.h"


@interface YMTrafficHourly : YMAbstractChildEntity

@property (nonatomic, strong) NSDate *hours;
@property (nonatomic, strong) NSNumber *avgVisit;

@property (nonatomic, strong) NSNumber *denial;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *visitTime;

@end