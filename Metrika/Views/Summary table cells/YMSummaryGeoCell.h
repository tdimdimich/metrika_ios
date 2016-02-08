//
// Created by Dmitry Korotchenkov on 16/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMValueTypeStringFormat;


@interface YMSummaryGeoCell : UITableViewCell
- (void)fillWithFirstTitle:(NSString *)firstTitle firstValue:(YMValueTypeStringFormat *)firstValue secondTitle:(NSString *)secondTitle secondValue:(YMValueTypeStringFormat *)secondValue thirdTitle:(NSString *)thirdTitle thirdValue:(YMValueTypeStringFormat *)thirdValue color:(UIColor *)color;
@end