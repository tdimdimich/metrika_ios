//
// File: YMCounterListHeaderCell.h
// Project: Metrika
//
// Created by dkorneev on 8/29/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMCounterListHeaderCell : UITableViewCell
+ (CGFloat)cellHeight;

- (void)setTitle:(NSString *)title;
@end