//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMObjectForGrouping : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic) float visits;
@property(nonatomic) float pageViews;

@property(nonatomic) float denialSum;
@property(nonatomic) float visitTimeSum;

- (id)initWithName:(NSString *)name visits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime;

- (void)addVisits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime;

- (float)depth;

- (float)visitTime;

- (float)denial;

@end