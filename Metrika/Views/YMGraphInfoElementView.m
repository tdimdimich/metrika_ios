//
// Created by Dmitry Korotchenkov on 15/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMGraphInfoElementView.h"
#import "NSDate+DKAdditions.h"
#import "YMElementModel.h"

@interface YMGraphInfoElementView ()
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property(nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *totalValueTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel *minComma;
@property(nonatomic, strong) IBOutlet UILabel *maxComma;
@property(nonatomic, strong) IBOutlet UILabel *minValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *maxValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *minDateLabel;
@property(nonatomic, strong) IBOutlet UILabel *maxDateLabel;

@end

@implementation YMGraphInfoElementView

+ (YMGraphInfoElementView *)createView {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YMGraphInfoElementView" owner:nil options:nil];
    return [topLevelObjects objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalValueLabel.text = NSLocalizedString(@"VF-seconds", nil);
    self.maxLabel.text = NSLocalizedString(@"Max", @"макс.:");
    self.minLabel.text = NSLocalizedString(@"Min", @"мин.:");
}

- (void)fillWithModel:(YMElementModel *)model color:(UIColor *)color {
    self.totalValueLabel.textColor = color ?: [UIColor blackColor];
    self.totalValueTypeLabel.textColor = color ?: [UIColor blackColor];
    self.totalValueLabel.text = model.totalString;
    self.totalValueTypeLabel.text = model.totalType ?: @"";
    self.minValueLabel.text = model.minValueString;
    self.maxValueLabel.text = model.maxValueString;
    if (model.minDate && model.maxDate) {
        self.minDateLabel.hidden = self.maxDateLabel.hidden = self.minComma.hidden = self.maxComma.hidden = NO;
        self.minDateLabel.text = [model.minDate stringWithFormat:@"dd.LL"];
        self.maxDateLabel.text = [model.maxDate stringWithFormat:@"dd.LL"];
    } else {
        self.minDateLabel.hidden = self.maxDateLabel.hidden = self.minComma.hidden = self.maxComma.hidden = YES;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.totalValueTypeLabel sizeToFit];
    self.totalValueTypeLabel.right = 89; // provided by xib
    [self.totalValueLabel sizeToFit];
    self.totalValueLabel.centerY = self.innerCenterY;
    self.totalValueLabel.right = self.totalValueTypeLabel.left;
    self.totalValueTypeLabel.bottom = self.totalValueLabel.bottom - 3;
}


@end