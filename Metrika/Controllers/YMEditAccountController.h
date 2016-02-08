//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMCounterSettingsCell.h"

@class YMAccountInfo;


@interface YMEditAccountController : UIViewController <UITableViewDelegate, UITableViewDataSource, YMCounterSettingsCellDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
- (void)setAccountInfo:(YMAccountInfo *)accountInfo;
@end