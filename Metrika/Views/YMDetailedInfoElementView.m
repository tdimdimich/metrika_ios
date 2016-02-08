//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDetailedInfoElementView.h"
#import "YMDetailedElementModel.h"
#import "UIColor+YMAdditions.h"

@interface YMDetailedInfoElementView ()
@property (weak, nonatomic) IBOutlet UILabel *secLabel;

@property(nonatomic, strong) IBOutlet UILabel *title;
@property(nonatomic, strong) IBOutlet UILabel *valueLabel;
@property(nonatomic, strong) IBOutlet UILabel *valueTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel *percentLabel;
@property(nonatomic, strong) IBOutlet UIView *percentView;

@end

@implementation YMDetailedInfoElementView

+ (YMDetailedInfoElementView *)createView {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YMDetailedInfoElementView" owner:nil options:nil];
    return [topLevelObjects objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.secLabel.text = NSLocalizedString(@"VF-seconds", nil);
}

- (void)fillWithColor:(UIColor *)color model:(YMDetailedElementModel *)model {
    UIColor *blackColor = [UIColor blackColor];
    color = color ?: blackColor;
    NSString *title = model.title ?: @"";

    self.percentLabel.right = self.percentLabel.superview.width - 5;
    self.title.text = title;
    self.valueLabel.textColor = color;
    self.valueTypeLabel.textColor = color;
    self.valueLabel.text = model.value;
    self.valueTypeLabel.text = model.valueType ?: @"";
    NSString *stringValue = (roundf(model.percent) == model.percent) ? [NSString stringWithFormat:@"%0.0f", model.percent] : [NSString stringWithFormat:@"%0.2f", model.percent];
    self.percentLabel.text = [stringValue stringByAppendingString:@"%"];
    self.percentView.backgroundColor = color;
    self.percentView.left = 0;
    self.percentView.width = self.percentView.superview.width * model.percent / 100;

    CGSize percentLabelSize = [self.percentLabel.text sizeWithFont:self.percentLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    if (self.percentLabel.right - percentLabelSize.width - 5 < self.percentView.width) {
        self.percentLabel.right = self.percentView.width - 5;
        self.percentLabel.textColor = [color isEqualToColor:blackColor] ? [UIColor whiteColor] : blackColor;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.valueTypeLabel sizeToFit];
    self.valueTypeLabel.right = 145;
    [self.valueLabel sizeToFit];
    self.valueLabel.centerY = self.innerCenterY;
    self.valueLabel.right = self.valueTypeLabel.left;
    self.valueTypeLabel.bottom = self.valueLabel.bottom - 2.5;
}


@end