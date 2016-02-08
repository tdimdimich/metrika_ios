//
// File: YMDotLine.m
// Project: Metrika
//
// Created by dkorneev on 9/27/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import <DKHelper/DKUtils.h>
#import "YMDotLine.h"


@interface YMDotLine ()

@end

@implementation YMDotLine

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.color = [DKUtils colorWithRed:155 green:155 blue:153];
        self.diameter = 2.0;
        self.dotToDotSpace = 3.0;
    }
    return self;
}

- (void)setDotToDotSpace:(float)dotToDotSpace {
    _dotToDotSpace = dotToDotSpace;
    [self setNeedsDisplay];
}

- (void)setDiameter:(float)diameter {
    _diameter = diameter;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect circleRect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    NSUInteger count = (NSUInteger) roundf(self.width / (self.diameter + self.dotToDotSpace));
    for (NSUInteger i = 0; i < count; i++) {
        circleRect = CGRectMake(i * (self.dotToDotSpace + self.diameter) + self.dotToDotSpace, 0, self.diameter, self.diameter);
        CGContextFillEllipseInRect(context, circleRect);
    }
    CGContextRestoreGState(context);
}

@end