//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractSettingsCell.h"


@interface YMAccessoryButtonSettingsCell : YMAbstractSettingsCell
- (void)fillWithMainText:(NSString *)mainText detailedText:(NSString *)detailedText accessoryButtonTitle:(NSString *)accessoryButtonTitle;

- (void)addAccessoryTapTarget:(id)target1 action:(SEL)action;
@end