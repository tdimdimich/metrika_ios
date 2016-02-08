//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDiagramTableCell.h"
#import "YMUtils.h"
#import "YMValueTypeStringFormat.h"

static CGFloat const kLandscapeLabelsMargin = 12;
static CGFloat const kPortraitLabelsMargin = 5;
static CGFloat const kLandscapeFontSize = 14;
static CGFloat const kPortraitFontSize = 10;

@interface YMDiagramTableCell ()

@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *valueLabel;
@property(nonatomic, strong) IBOutlet UILabel *typeLabel;
@property(nonatomic, strong) IBOutlet UIView *progressView;
@property(nonatomic, strong) IBOutlet UIView *separatorView;

@property(nonatomic) CGFloat progress;
@property(nonatomic) BOOL isLandscape;

@end

@implementation YMDiagramTableCell

+ (instancetype)createCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMDiagramCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isLandscape) {
        self.titleLabel.font = self.valueLabel.font = self.typeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:kLandscapeFontSize];
    } else {
        self.titleLabel.font = self.valueLabel.font = self.typeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:kPortraitFontSize];
    }
    CGFloat margin = self.isLandscape ? kLandscapeLabelsMargin : kPortraitLabelsMargin;
    [self.typeLabel sizeToFit];
    [self.valueLabel sizeToFit];
    self.titleLabel.centerY = self.valueLabel.centerY = self.typeLabel.centerY = self.innerCenterY;
    self.typeLabel.right = self.width - margin;
    self.titleLabel.left = margin;
    self.valueLabel.right = self.typeLabel.left;
    self.titleLabel.width = self.valueLabel.left - 2 * margin;
    self.progressView.width = self.width * self.progress;
    self.separatorView.left = 0;
    self.separatorView.bottom = self.height;
    self.separatorView.width = self.width;
}


- (void)fillWithTitle:(NSString *)title progerss:(CGFloat)progress color:(UIColor *)color isLandscape:(BOOL)isLandscape {
    self.isLandscape = isLandscape;
    self.titleLabel.text = title;
    self.valueLabel.text = [YMValueTypeStringFormat formatFromFloatValue:progress].value;
    self.typeLabel.text = @"%";
    self.progress = progress / 100;
    self.progressView.backgroundColor = color;
    [self setNeedsLayout];
}


@end