//
// Created by Dmitry Korotchenkov on 16/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMSummaryAgeCell : UITableViewCell
- (void)fillWithFirstTitle:(NSString *)firstTitle firstPercent:(CGFloat)firstPercent secondTitle:(NSString *)secondTitle secondPercent:(CGFloat)secondPercent thirdTitle:(NSString *)thirdTitle thirdPercent:(CGFloat)thirdPercent color:(UIColor *)color;
@end