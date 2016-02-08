//
// File: YMOverlayView.m
// Project: Metrika
//
// Created by dkorneev on 10/16/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMOverlayView.h"


@implementation YMOverlayView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point))
            return YES;
    }
    return NO;
}

@end