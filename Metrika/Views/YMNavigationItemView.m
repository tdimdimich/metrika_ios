//
// Created by Dmitry Korotchenkov on 05/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMNavigationItemView.h"
#import "YMUtils.h"


@implementation YMNavigationItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        // if it's left button
        if (self.left < 160) {
            self.bounds = CGRectMake(10, 0, self.bounds.size.width, self.bounds.size.height);
        }
        else { // if it's right button
            self.bounds = CGRectMake(-10, 0, self.bounds.size.width, self.bounds.size.height);
        }
    }
}

@end