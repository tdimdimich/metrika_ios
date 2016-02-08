//
// File: YMDatePickerController.h
// Project: Metrika
//
// Created by dkorneev on 10/9/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMCounterInfo;

typedef void (^YMDatePickerConfirmBlock)(NSDate *dateStart, NSDate *dateEnd);

@interface YMDatePickerController : UIViewController <UIGestureRecognizerDelegate>
- (void)setCounter:(YMCounterInfo *)counter;
@property (copy) YMDatePickerConfirmBlock confirmBlock;
@end