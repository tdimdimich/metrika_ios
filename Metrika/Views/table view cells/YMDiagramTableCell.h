//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kDiagramTableCellID = @"diagramTableCellID";
static CGFloat const kDiagramTableCellPortraitHeight = 23;
static CGFloat const kDiagramTableCellLandscapeMinHeight = 56;

@interface YMDiagramTableCell : UITableViewCell

+ (instancetype)createCell;

- (void)fillWithTitle:(NSString *)title progerss:(CGFloat)progress color:(UIColor *)color isLandscape:(BOOL)isLandscape;

@end