//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "YMAbstractChildEntity.h"


@interface YMGeo : YMAbstractChildEntity <YMStandardStatObject>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *countryID;
@property (nonatomic, strong) NSNumber *visits;
@property (nonatomic, strong) NSNumber *pageViews;

@property (nonatomic, strong) NSNumber *denial;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *visitTime;

@end