//
// File: YMRateView.m
// Project: Metrika
//
// Created by dkorneev on 5/13/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import "YMRateView.h"
#import "YMTipsManager.h"

@interface YMRateView ()
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation YMRateView

- (void)awakeFromNib {
    [self.rateButton setTitle:NSLocalizedString(@"Rate-rateButton", @"Оценить Миллиметрику") forState:UIControlStateNormal];
    [self.remindButton setTitle:NSLocalizedString(@"Rate-remindButton", @"Напомнить позже") forState:UIControlStateNormal];
    self.skipLabel.text = NSLocalizedString(@"Rate-skipButton", @"Нет, спасибо (продолжить)");

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Rate-Message", @"rateMessage")
                                                                                attributes:@{
                                                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15],
                                                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                }];
    NSRange range = [NSLocalizedString(@"Rate-Message", @"rateMessage") rangeOfString:NSLocalizedString(@"Rate-AppName", nil)];
    if (range.location != NSNotFound) {
        [message addAttributes:@{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:15],
                NSForegroundColorAttributeName : [UIColor whiteColor]
        }
                         range:range];
    }
    self.messageLabel.attributedText = message;
}

- (IBAction)skipButtonTap:(id)sender {
    [YMTipsManager setRateViewWasShown];

    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

- (IBAction)remindButtonTap:(id)sender {
    [YMTipsManager incrementLaunchCounter];
    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

- (IBAction)rateButtonTap:(id)sender {
    [YMTipsManager setRateViewWasShown];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id840372237" relativeToURL:nil]];

    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

@end