//
// File: YMRotateTipView.m
// Project: Metrika
//
// Created by dkorneev on 4/28/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import "YMRotateTipView.h"

@interface YMRotateTipView()
@property (weak, nonatomic) IBOutlet UILabel *continueLabel;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@end

@implementation YMRotateTipView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.continueLabel.text = NSLocalizedString(@"Advice-Continue", @"Нажмите на экран\nчтобы продолжить.");
    self.adviceLabel.text = NSLocalizedString(@"Advice-Rotate", @"Поверните телефон,\nчтобы подробнее ознакомиться\nс графиком.");

}


@end