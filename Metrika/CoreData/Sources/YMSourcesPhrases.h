//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractChildEntity.h"
#import "YMStandardStatDataSource.h"


@interface YMSourcesPhrases : YMAbstractChildEntity <YMStandardStatObject>

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *phrase;
@property (nonatomic, strong) NSNumber *visits;
@property (nonatomic, strong) NSNumber *pageViews;

@property (nonatomic, strong) NSNumber *denial;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *visitTime;

@property (nonatomic, strong) NSSet *searchEngines;

@end