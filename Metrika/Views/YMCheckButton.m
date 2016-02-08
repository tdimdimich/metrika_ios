//
// File: YMCheckButton.m
// Project: Metrika
//
// Created by dkorneev on 8/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCheckButton.h"

@interface YMCheckButton ()
@property(nonatomic, weak) NSObject *target;
@property(nonatomic) SEL selector;
@end

@implementation YMCheckButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addTarget:(NSObject *)target action:(SEL)action {
    self.target = target;
    self.selector = action;
}

- (void)buttonTapped {
    self.selected = !self.selected;
    if (self.target && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:self];
    }
}

@end