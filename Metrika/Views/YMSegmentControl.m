//
// Created by Dmitry Korotchenkov on 12/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMSegmentControl.h"


@interface YMSegmentControl ()
@property(nonatomic, strong) NSArray *buttons;
@end

@implementation YMSegmentControl
- (void)awakeFromNib {
    [super awakeFromNib];
    NSMutableArray *buttons = [NSMutableArray new];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *) subview;
            [button addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
        }
    }
    self.buttons = [NSArray arrayWithArray:buttons];
}

- (void)didSelect:(UIButton *)selectedButton {
    for (UIButton *button in self.buttons) {
        button.selected = [button isEqual:selectedButton];
    }
}

@end