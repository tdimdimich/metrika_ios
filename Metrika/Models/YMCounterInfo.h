//
// File: YMCounterInfo.h
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YMCounter;
@class YMAccountInfo;
@class YMGradientColor;


@interface YMCounterInfo : NSManagedObject
@property (nonatomic, strong) YMGradientColor *color;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL hidden;
@property(nonatomic, strong) YMCounter *counter;
@property(nonatomic, strong) YMAccountInfo *accountInfo;
@property(nonatomic, strong) NSDate *dateStart;
@property(nonatomic, strong) NSDate *dateEnd;
- (NSString *)siteName;

- (void)fillWithCounterInfo:(YMCounterInfo *)info;
@end