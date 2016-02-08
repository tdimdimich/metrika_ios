//
// Created by Dmitry Korotchenkov on 24/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMTipsManager : NSObject

+ (void)showTipForScreenWithMenuAfterDelayIfNeeded;
+ (void)showTipForRotatingScreenAfterDelayIfNeeded;

+ (void)didRotateScreen;

+ (BOOL)isMenuSwipeTipWasShown;

+ (void)setMenuSwipeTipWasShown;

+ (void)incrementLaunchCounter;

+ (void)setRateViewWasShown;

+ (BOOL)isRateViewWasShown;

+ (BOOL)shouldShowRateView;

+ (void)showRateView;

@end