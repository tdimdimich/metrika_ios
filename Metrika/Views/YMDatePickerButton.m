//
// File: YMDatePickerButton.m
// Project: Metrika
//
// Created by dkorneev on 10/9/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/DKUtils.h>
#import "YMDatePickerButton.h"

@implementation YMDatePickerButton

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.selected = NO;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title forState:UIControlStateNormal];
    [super setTitle:title forState:UIControlStateSelected];
    [super setTitle:title forState:UIControlStateDisabled];
    [super setTitle:title forState:UIControlStateHighlighted];
}


- (void)configForSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [DKUtils colorWithRed:38 green:152 blue:232];
        self.titleLabel.textColor = [UIColor whiteColor];

    } else {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [DKUtils colorWithRed:38 green:152 blue:232];
    }
}

- (void)setGrayState:(BOOL)enabled {
    if (enabled) {
        [self setSelected:NO];
    }
    UIColor *color = enabled ? [DKUtils colorWithRed:200 green:200 blue:200] : [DKUtils colorWithRed:38 green:152 blue:232];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = color;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted)
        [self configForSelected:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self configForSelected:selected];
}


@end