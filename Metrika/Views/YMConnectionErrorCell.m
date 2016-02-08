//
// File: YMConnectionErrorCell.m
// Project: Metrika
//
// Created by dkorneev on 4/28/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import "YMConnectionErrorCell.h"

@interface YMConnectionErrorCell()
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@end

@implementation YMConnectionErrorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.adviceLabel.text = NSLocalizedString(@"Alert-CheckConnectionAdvice", @"Проверьте подключение к интернету\nили повторите запрос позднее.");
    self.alertLabel.text = NSLocalizedString(@"Alert-ConnectionError", @"При попытке связаться с сервером,\nпроизошла ошибка.");

}

@end