//
// File: YMMenuCell.m
// Project: Metrika
//
// Created by dkorneev on 9/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import "YMConstants.h"
#import <DKHelper/DKUtils.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMMenuCell.h"
#import "YMDotLine.h"

@interface YMMenuCell ()
@property (weak, nonatomic) IBOutlet YMDotLine *separator;
@property(weak, nonatomic) IBOutlet UIImageView *openedCellIcon;
@property(weak, nonatomic) IBOutlet UIImageView *moreItemsIcon;
@property(weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation YMMenuCell

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setChosen:NO];
        [self setCellType:YMMenuCellTypeFirstLevel];
        self.highlighted = YES;
        self.selected = YES;
    }
    return self;
}

- (void)setCellType:(YMMenuCellType)type {
    if (type == YMMenuCellTypeFirstLevel) {
        self.label.left = 20;
        self.separator.color = [DKUtils colorWithRed:155 green:155 blue:153];
        self.separator.left = 5;

    } else {
//        self.label.left = 24;
        self.label.left = 32;
        self.separator.color = [DKUtils colorWithRed:86 green:86 blue:82];
        self.separator.left = 17;
    }
    self.separator.width = self.width - self.separator.left;
    [self setNeedsDisplay];
}

- (void)setOpenedCellIconHidden:(BOOL)openedCellIconHidden {
    _openedCellIconHidden = openedCellIconHidden;
    self.openedCellIcon.hidden = _openedCellIconHidden;
}

- (void)setMoreItemsIconHidden:(BOOL)moreItemsIconHidden {
    _moreItemsIconHidden = moreItemsIconHidden;
    self.moreItemsIcon.hidden = _moreItemsIconHidden;
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
    if (_chosen) {
        self.label.font = [UIFont fontWithName:kFontBold size:15];
        self.label.textColor = [DKUtils colorWithRed:36 green:161 blue:232];

    } else {
        self.label.font = [UIFont fontWithName:kFontRegular size:15];
        self.label.textColor = [UIColor whiteColor];
    }
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

@end