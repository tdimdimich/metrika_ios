//
//  YMAppDelegate.h
//  Metrika
//
//  Created by Dmitry Korotchenkov on 12.06.13.
//  Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMTrafficSummaryService;
@class YMMenuController;

@interface YMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, weak) YMMenuController *menuController;

- (BOOL)shouldAutorotate;

@end
