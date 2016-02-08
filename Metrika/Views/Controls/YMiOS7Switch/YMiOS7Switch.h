//
// Created by Dmitry Korotchenkov on 18.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


static const int kiOS7SwitchWidth = 53;
static const int kiOS7SwitchHeight = 34;

@interface YMiOS7Switch : UIView
@property (nonatomic) BOOL selected;

- (void)addSwitchChangeTarget:(id)target action:(SEL)action;
@end