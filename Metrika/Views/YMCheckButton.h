//
// File: YMCheckButton.h
// Project: Metrika
//
// Created by dkorneev on 8/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMCheckButton : UIButton

// sets selector which will be called on UIControlEventTouchUpInside
- (void)addTarget:(NSObject *)target action:(SEL)action;

@end