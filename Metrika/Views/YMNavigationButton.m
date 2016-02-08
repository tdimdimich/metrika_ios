//
// Created by Dmitry Korotchenkov on 04/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMNavigationButton.h"
#import "YMUtils.h"


@implementation YMNavigationButton

- (UIEdgeInsets)alignmentRectInsets {
    if (SYSTEM_VERSION_LESS_THAN_7) {
        UIEdgeInsets insets;
        // if it's left button
        if (self.left < self.superview.width/2) {
            insets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        else { // if it's right button
            insets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return insets;
    } else {
        return [super alignmentRectInsets];
    }
}

@end