//
// File: YMCounterMenuController.h
// Project: Metrika
//
// Created by dkorneev on 8/21/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMCounterTableController.h"


@interface YMCounterMenuController : UIViewController <YMCounterTableControllerProtocol>
@property(nonatomic, readonly) BOOL isShown;

- (void)maximizeAnimated:(BOOL)animated;
- (void)minimizeAnimated:(BOOL)animated;

- (CGFloat)minHeight;
@end