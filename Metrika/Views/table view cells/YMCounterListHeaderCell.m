//
// File: YMCounterListHeaderCell.m
// Project: Metrika
//
// Created by dkorneev on 8/29/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCounterListHeaderCell.h"

@interface YMCounterListHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation YMCounterListHeaderCell

+ (CGFloat)cellHeight {
    static const CGFloat height = 55.0;
    return height;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:228.0 /255.0 green:228.0 /255.0 blue:228.0 /255.0 alpha:1];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

@end