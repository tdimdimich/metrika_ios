//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDiagramInfoElementView.h"
#import "YMUtils.h"
#import "YMValueTypeStringFormat.h"

@interface YMDiagramInfoElementView ()

@property(nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *totalValueTypeLabel;

@end

@implementation YMDiagramInfoElementView

+ (YMDiagramInfoElementView *)createView {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YMDiagramInfoElementView" owner:nil options:nil];
    return [topLevelObjects objectAtIndex:0];
}

- (void)fillWithValue:(CGFloat)value color:(UIColor *)color {
    self.totalValueLabel.textColor = self.totalValueTypeLabel.textColor = color ?: [UIColor blackColor];
    YMValueTypeStringFormat *format = [YMValueTypeStringFormat formatFromFloatValue:value];
    self.totalValueLabel.text = format.value;
    self.totalValueTypeLabel.text = format.type;
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