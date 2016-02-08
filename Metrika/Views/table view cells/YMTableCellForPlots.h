//
// Created by Dmitry Korotchenkov on 17/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

static NSString *const kTableCellForPlotsID = @"YMTableCellForPlotsID";
static CGFloat const kTableCellForPlotBottomBarHeight = 39;

@interface YMTableCellForPlots : UITableViewCell
+ (YMTableCellForPlots *)createCell;

- (void)setColor:(UIColor *)color;

- (void)setListData:(NSArray *)array selectedIndex:(NSUInteger)index1 target:(NSObject *)target action:(SEL)action;

- (void)setChangeTypeTarget:(NSObject *)target action:(SEL)action;

- (void)hideGraphTypeButton;
@end