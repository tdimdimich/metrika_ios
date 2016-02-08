//
// File: YMAccountInfo.h
// Project: Metrika
//
// Created by dkorneev on 8/29/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YMAccountInfo : NSManagedObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSSet *counterInfo;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL shouldBeRemoved;

- (NSArray *)visibleCountersInfo;
@end