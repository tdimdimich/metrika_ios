//
// Created by Dmitry Korotchenkov on 18.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMNavigationBar.h"
#import "DKUtils.h"
#import "UIImage+DKAdditions.h"


@implementation YMNavigationBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self customize];
}

- (void)customize {
    [self setTranslucent:NO];
    [self setBackgroundImage:[UIImage imageWithFrame:self.bounds color:[DKUtils colorWithRed:248 green:248 blue:248]] forBarMetrics:UIBarMetricsDefault];
    self.clipsToBounds = YES;
}

@end