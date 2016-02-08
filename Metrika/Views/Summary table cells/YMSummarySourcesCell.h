//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMValueTypeStringFormat;


@interface YMSummarySourcesCell : UITableViewCell
- (void)fillWithMaxValue:(YMValueTypeStringFormat *)maxValue maxText:(NSString *)maxText secondValue:(YMValueTypeStringFormat *)secondValue secondText:(NSString *)secondText trirdValue:(YMValueTypeStringFormat *)thirdValue thirdText:(NSString *)thirdText;
@end