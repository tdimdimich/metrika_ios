//
// Created by Dmitry Korotchenkov on 12/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UINavigationController+YMAdditions.h"
#import "YMAppDelegate.h"
#import "YMUtils.h"


@implementation UINavigationController (YMAdditions)

- (BOOL)shouldAutorotate {
    return APPDELEGATE.shouldAutorotate ||
            [[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait;
}

@end