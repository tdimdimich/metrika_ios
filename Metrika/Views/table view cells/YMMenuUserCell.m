//
// File: YMMenuUserCell.m
// Project: Metrika
//
// Created by dkorneev on 9/24/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/DKUtils.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMMenuUserCell.h"

@interface YMMenuUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineBreaker;
@end

@implementation YMMenuUserCell

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentView.backgroundColor = [DKUtils colorWithRed:36 green:161 blue:232];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.nameLabel.text = title;

    CGRect rect = self.nameLabel.frame;
    rect.size.width = 500; // just big value
    CGSize labelSize = [title sizeWithFont:self.nameLabel.font constrainedToSize:rect.size lineBreakMode:self.nameLabel.lineBreakMode];
    self.lineBreaker.hidden = labelSize.width <= self.nameLabel.width;
}

- (void)setAvatarImage:(UIImage *)image {
    self.avatarImageView.image = image;
}

#pragma mark user interactions

- (IBAction)settingsButtonTap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(settingsButtonTap) to:nil from:self forEvent:nil];
}

- (IBAction)exitButtonTap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(exitButtonTap) to:nil from:self forEvent:nil];
}

@end