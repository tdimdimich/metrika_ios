//
// Created by Dmitry Korotchenkov on 07/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMValueTypeStringFormat;


@interface YMSummaryVisitorsCell : UITableViewCell
- (void)fillWithColor:(UIColor *)color totalValue:(YMValueTypeStringFormat *)totalValue dailyValue:(YMValueTypeStringFormat *)dailyValue;
@end