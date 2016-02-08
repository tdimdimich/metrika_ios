//
// File: YMProgressBarController.m
// Project: Metrika
//
// Created by dkorneev on 8/28/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "YMProgressBarController.h"
#import "YMProgressBar.h"

@interface YMProgressBarController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet YMProgressBar *progressBar;
@end

@implementation YMProgressBarController

- (void)viewDidLoad {
    self.progressBar.alpha = self.label.alpha = 1;

    self.label.shadowColor = [UIColor blackColor];
    self.label.shadowOffset = CGSizeMake(0, 1);

    self.progressBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.progressBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.progressBar.layer.shadowRadius = 5;
    self.progressBar.layer.shadowOpacity = 0.5;
}

- (void)setBackgroundImage:(UIImage *)image {
//    if (self.imageView) {
//        [self.imageView setImage:image];
//    }
}

- (void)setProgress:(NSUInteger)progress {
    [self.progressBar setProgress:progress animated:YES];
}

@end