//
// File: YMMenuTipView.m
// Project: Metrika
//
// Created by dkorneev on 4/28/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import "YMMenuTipView.h"

@interface YMMenuTipView()
@property (weak, nonatomic) IBOutlet UILabel *continueLabel;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@end

@implementation YMMenuTipView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.continueLabel.text = NSLocalizedString(@"Advice-Continue", @"Нажмите на экран\nчтобы продолжить.");
    self.adviceLabel.text = NSLocalizedString(@"Advice-Scroll", @"Сдвиньте экран вправо,\nчтобы открыть меню.");
}

@end