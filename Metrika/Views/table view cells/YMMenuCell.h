//
// File: YMMenuCell.h
// Project: Metrika
//
// Created by dkorneev on 9/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum {
    YMMenuCellTypeFirstLevel,
    YMMenuCellTypeSecondLevel
} YMMenuCellType;

@interface YMMenuCell : UITableViewCell
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL openedCellIconHidden;
@property (nonatomic) BOOL moreItemsIconHidden;

- (void)setCellType:(YMMenuCellType)type;

- (void)setTitle:(NSString *)title;
@end