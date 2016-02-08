//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

static const int kTableSectionHeaderHeight = 56;

@interface YMTableHeaderView : UIView
+ (UIView *)createSectionHeaderWithTitle:(NSString *)title forWidth:(CGFloat)width;
@end