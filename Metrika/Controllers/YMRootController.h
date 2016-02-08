//
// File: YMRootController.h
// Project: Metrika
//
// Created by dkorneev on 9/19/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMMenuController.h"


@interface YMRootController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong, readonly) UIViewController *activeController;

- (void)showFilterMenu;

- (void)hideFilterMenu;

- (BOOL)isMenuShown;

- (void)showController:(UIViewController *)controller;

@end