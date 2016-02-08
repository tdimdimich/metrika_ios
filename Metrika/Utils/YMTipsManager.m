//
// Created by Dmitry Korotchenkov on 24/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "YMTipsManager.h"
#import "YMUtils.h"
#import "YMRateView.h"

static NSString *const kMenuTipKey = @"menuTipKey";
static NSString *const kMenuSwipeTipKey = @"menuSwipeTipKey";
static NSString *const kRotateTipKey = @"rotateTipKey";
static NSString *const kLaunchCounter = @"launchCounter";
static NSString *const kRateViewKey = @"rateViewKey";

static const int tipsDelay = 5;

static BOOL inProgress = NO;

@implementation YMTipsManager

+ (void)showTipForScreenWithMenuAfterDelayIfNeeded {
    if (![self isMenuTipWasShown] && !inProgress) {
        inProgress = YES;
        [self performSelector:@selector(showMenuTip) withObject:nil afterDelay:tipsDelay];
    }
}

+ (void)showTipForRotatingScreenAfterDelayIfNeeded {
    if (![self isRotateTipWasShown] && !inProgress) {
        inProgress = YES;
        [self performSelector:@selector(showRotateTip) withObject:nil afterDelay:tipsDelay];
    }
}

+ (void)didRotateScreen {
    [self setRotateTipWasShown];
}

+ (void)showMenuTip {
    inProgress = NO;
    if ([self isMenuTipWasShown])
        return;

    [self setMenuTipWasShown];

    UIView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"YMMenuTip" owner:nil options:nil] objectAtIndex:0];
    tipView.frame = [APPDELEGATE window].bounds;
    [[APPDELEGATE window] addSubview:tipView];
    [tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [sender.view removeFromSuperview];
    }]];
}

+ (void)showRotateTip {
    inProgress = NO;
    if ([self isRotateTipWasShown])
        return;

    [self setRotateTipWasShown];

    UIView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"YMRotateTip" owner:nil options:nil] objectAtIndex:0];
    tipView.frame = [APPDELEGATE window].bounds;
    [[APPDELEGATE window] addSubview:tipView];
    [tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [sender.view removeFromSuperview];
    }]];
}

+ (BOOL)isMenuTipWasShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMenuTipKey];
}

+ (void)setMenuTipWasShown {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMenuTipKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isMenuSwipeTipWasShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMenuSwipeTipKey];
}

+ (void)setMenuSwipeTipWasShown {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMenuSwipeTipKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isRotateTipWasShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRotateTipKey];
}

+ (void)setRotateTipWasShown {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRotateTipKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)incrementLaunchCounter {
    NSInteger launchCounter = [[NSUserDefaults standardUserDefaults] integerForKey:kLaunchCounter];
    [[NSUserDefaults standardUserDefaults] setInteger:++launchCounter forKey:kLaunchCounter];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setRateViewWasShown {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRateViewKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isRateViewWasShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRateViewKey];
}

+ (BOOL)shouldShowRateView {
    if ([self isRateViewWasShown])
        return NO;

    NSInteger launchCounter = [[NSUserDefaults standardUserDefaults] integerForKey:kLaunchCounter];
    return (launchCounter % 5 == 0);
}

+ (void)showRateView {
    YMRateView *view = [[[NSBundle mainBundle] loadNibNamed:@"RateTip" owner:nil options:nil] objectAtIndex:0];
    view.completionBlock = ^(UIView *sender) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.25
                         animations:^{
                             sender.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [sender removeFromSuperview];
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];
    };
    view.frame = [APPDELEGATE window].bounds;
    [[APPDELEGATE window] addSubview:view];

    view.alpha = 0;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25
                     animations:^{
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

@end