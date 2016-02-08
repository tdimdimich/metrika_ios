//
// File: YMDatePickerButton.h
// Project: Metrika
//
// Created by dkorneev on 10/9/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMCheckButton.h"


@interface YMDatePickerButton : UIButton

- (void)setTitle:(NSString *)title;

- (void)setGrayState:(BOOL)enabled;

@end