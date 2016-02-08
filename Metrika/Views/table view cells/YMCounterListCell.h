//
// File: YMCounterListCell.h
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMGradientColor;

typedef enum {
    YMCounterListCellBorderStyleNone,
    YMCounterListCellBorderStyleBottom
} YMCounterListCellBorderStyle;

@interface YMCounterListCell : UITableViewCell
+ (CGFloat)cellHeight;

- (void)setTitle:(NSString *)title color:(UIColor *)color selected:(BOOL)selected borderStyle:(YMCounterListCellBorderStyle)borderStyle;
@end