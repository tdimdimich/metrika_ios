//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMTableHeaderView.h"


@implementation YMTableHeaderView

+ (UIView *)createSectionHeaderWithTitle:(NSString *)title forWidth:(CGFloat)width {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kTableSectionHeaderHeight)];
    view.backgroundColor = [DKUtils colorWithRed:247 green:247 blue:247];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 1, width, 1)];
    separator.backgroundColor = [DKUtils colorWithRed:200 green:200 blue:200];
    [view addSubview:separator];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, 30, width - 12, 20)];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:14.5];
    label.textColor = [DKUtils colorWithRed:85 green:85 blue:85];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    [view addSubview:label];
    return view;
}

@end