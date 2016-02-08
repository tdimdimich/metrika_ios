//
// Created by Dmitry Korotchenkov on 07/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMValueTypeStringFormat;


@interface YMSummaryTimeCell : UITableViewCell
- (void)fillWithTotalValue:(YMValueTypeStringFormat *)totalValue maxRecordValue:(YMValueTypeStringFormat *)maxRecordValue maxRecordDate:(NSDate *)maxRecordDate;
@end