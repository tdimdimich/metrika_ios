//
// File: YMCounterListCell.m
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCounterListCell.h"
#import "YMCircleView.h"
#import "YMGradientColor.h"

@interface YMCounterListCell ()
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;
@property (weak, nonatomic) IBOutlet YMCircleView *circleView;
@property(weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation YMCounterListCell

+ (CGFloat)cellHeight {
    static const CGFloat height = 45.0;
    return height;
}

- (void)setTitle:(NSString *)title color:(UIColor *)color selected:(BOOL)selected borderStyle:(YMCounterListCellBorderStyle)borderStyle {
    self.label.text = title;
    self.label.textColor = color;
    self.circleView.color = color;
    self.circleView.selected = selected;
    switch (borderStyle) {
        case YMCounterListCellBorderStyleBottom:
            self.bottomBorder.hidden = NO;
            break;

        case YMCounterListCellBorderStyleNone:
        default:
            self.bottomBorder.hidden = YES;
            break;
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end