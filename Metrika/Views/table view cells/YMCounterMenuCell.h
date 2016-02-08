//
// File: YMCounterMenuCell.h
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMCounterListCell.h"

@class YMCounterInfo;

@protocol YMCounterMenuCellProtocol
- (void)calendarButtonTap:(NSIndexPath *)indexPath;
@end

typedef enum {
    YMCounterMenuCellBorderStyleNone,
    YMCounterMenuCellBorderStyleTop
} YMCounterMenuCellBorderStyle;

@interface YMCounterMenuCell : UITableViewCell
+ (CGFloat)cellHeight;

- (void)setSettings:(YMCounterInfo *)settings indexPath:(NSIndexPath *)indexPath borderStyle:(YMCounterMenuCellBorderStyle)borderStyle;

@property (nonatomic, weak) id<YMCounterMenuCellProtocol> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end