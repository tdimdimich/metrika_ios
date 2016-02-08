//
// File: YMMenuController.h
// Project: Metrika
//
// Created by dkorneev on 9/19/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMSharingController.h"
#import <MessageUI/MessageUI.h>
#import <VK-ios-sdk/VKSdk.h>


@class YMMenuModel;

@interface YMMenuController : UIViewController <UITableViewDataSource, UITableViewDelegate, YMSharingControllerDelegate >

- (UIViewController *)openedController;

- (BOOL)isMenuOpened;

- (void)openTrafficSummaryController;
- (void)openSourcesSummaryController;
- (void)openGeoController;
- (void)openDemographyController;
- (void)openOSController;
- (void)openBrowsersController;

- (void)openLastController;

@end