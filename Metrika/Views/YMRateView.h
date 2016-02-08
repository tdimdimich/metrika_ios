//
// File: YMRateView.h
// Project: Metrika
//
// Created by dkorneev on 5/13/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMRateView : UIView

@property (copy)void (^completionBlock)(UIView *sender);

@end