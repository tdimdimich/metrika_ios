//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMSummaryOSCell : UITableViewCell
- (void)fillWithFirstName:(NSString *)firstName firstPercent:(CGFloat)firstPercent secondName:(NSString *)secondName secondPercent:(CGFloat)secondPercent thirdName:(NSString *)thirdName thirdPercent:(CGFloat)thirdPercent color:(UIColor *)color;
@end