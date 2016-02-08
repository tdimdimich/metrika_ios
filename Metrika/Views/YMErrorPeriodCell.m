//
// File: YMErrorPeriodCell.m
// Project: Metrika
//
// Created by dkorneev on 4/28/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import "YMErrorPeriodCell.h"

@interface YMErrorPeriodCell()
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end

@implementation YMErrorPeriodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.alertLabel.text = NSLocalizedString(@"Alert-ConnectionError", @"При попытке связаться с сервером, произошла ошибка.");
}


@end