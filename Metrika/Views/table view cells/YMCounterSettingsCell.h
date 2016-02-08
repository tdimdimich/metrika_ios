//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractCell.h"

@class YMCounterInfo;
@class YMCounterSettingsCell;

@protocol YMCounterSettingsCellDelegate
@optional
-(void)cell:(YMCounterSettingsCell *)cell didChangeVisibleState:(BOOL)stateNew;
-(void)cellDidEditTap:(YMCounterSettingsCell *)cell;
@end

@interface YMCounterSettingsCell : UITableViewCell
- (void)fillWithCounter:(YMCounterInfo *)counterInfo;

- (void)fillWithCounter:(YMCounterInfo *)counterInfo delegate:(NSObject <YMCounterSettingsCellDelegate> *)delegate;
@end