//
// File: YMAppSettings.h
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMCounterInfo.h"


static NSString *const kAppSettingsDidUpdateNotification = @"appSettingsDidUpdate";

@interface YMAppSettings : NSObject

+ (void)removeAccounts;

+ (NSArray *)getVisibleAccounts;

+ (NSArray *)getAccounts;

// must be called every time when you changing objects from persistent store
+ (void)commitUpdates;

+ (YMCounterInfo *)selectedCounter;

@end