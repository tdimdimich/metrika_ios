//
// Created by Dmitry Korotchenkov on 23.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMCheckCell.h"

@interface YMCheckCell ()

@property (nonatomic, strong) IBOutlet UIButton *checkButton;

@end

@implementation YMCheckCell

- (void)fillWithTitle:(NSString *)title checked:(BOOL)checked {
    [super fillWithTitle:title];
    self.checkButton.selected = checked;
}

@end