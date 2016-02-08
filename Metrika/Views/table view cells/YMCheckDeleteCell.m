//
// Created by Dmitry Korotchenkov on 01.10.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMCheckDeleteCell.h"


@implementation YMCheckDeleteCell

- (void)fillWithTitle:(NSString *)title checked:(BOOL)checked {
    self.titleLabel.textColor = checked ? [DKUtils colorWithRed:210 green:68 blue:68] : [UIColor blackColor];
    [super fillWithTitle:title checked:checked];
}

@end