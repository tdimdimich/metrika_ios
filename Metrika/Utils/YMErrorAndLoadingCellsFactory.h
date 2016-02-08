//
// Created by Dmitry Korotchenkov on 04/03/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMErrorAndLoadingCellsFactory : NSObject
+ (UITableViewCell *)errorConnectionCell;

+ (UITableViewCell *)errorPeriodCellWithText:(NSString *)text;

+ (UITableViewCell *)loadingCell;
@end