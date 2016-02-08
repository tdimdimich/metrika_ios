//
// File: YMCounterMenuCell.m
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCounterMenuCell.h"
#import "YMCircleView.h"
#import "YMCounterInfo.h"
#import "YMGradientColor.h"


@interface YMCounterMenuCell ()
@property(weak, nonatomic) IBOutlet UIButton *fromTimeButton;
@property(weak, nonatomic) IBOutlet UIButton *toTimeButton;
@property(weak, nonatomic) IBOutlet UIButton *toDateButton;
@property(weak, nonatomic) IBOutlet UIButton *fromDateButton;
@property(weak, nonatomic) IBOutlet UIButton *calendarButton;
@property(weak, nonatomic) IBOutlet UIView *separatorBot;
@property(weak, nonatomic) IBOutlet UIView *separatorTop;
@property(weak, nonatomic) IBOutlet UIView *separatorMid;
@property(weak, nonatomic) IBOutlet YMCircleView *circleView;
@property(weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation YMCounterMenuCell

+ (CGFloat)cellHeight {
    static const CGFloat kClosedHeight = 45;
    return kClosedHeight;
}

- (void)setSettings:(YMCounterInfo *)counterInfo indexPath:(NSIndexPath *)indexPath borderStyle:(YMCounterMenuCellBorderStyle)borderStyle {
    self.label.text = counterInfo.siteName;
    self.circleView.color = counterInfo.color.startColor;
    self.label.textColor = counterInfo.color.startColor;
    self.circleView.selected = counterInfo.selected;
    self.calendarButton.hidden = !counterInfo.selected;
    self.indexPath = indexPath;
    switch (borderStyle) {
        case YMCounterMenuCellBorderStyleTop:
            self.separatorTop.hidden = NO;
            self.separatorBot.hidden = NO;
            break;

        case YMCounterMenuCellBorderStyleNone:
            self.separatorTop.hidden = YES;
            self.separatorBot.hidden = NO;
            break;

        default:
            break;
    }

}

#pragma mark user interactions

- (IBAction)calendarButtonTap:(id)sender {
    if (self.delegate)
        [self.delegate calendarButtonTap:self.indexPath];
}

@end