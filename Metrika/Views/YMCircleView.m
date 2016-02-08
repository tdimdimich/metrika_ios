//
// File: YMCircleView.m
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCircleView.h"
#import "YMGradientColor.h"


@implementation YMCircleView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _color = [UIColor blackColor];
        _selected = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    static const CGFloat lineWidth = 1.0;
    CGContextSetLineWidth(context, lineWidth);

    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGRect rectInset = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
    CGContextAddEllipseInRect(context, rectInset);

    if (self.selected) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillEllipseInRect(context, rectInset);
    }

    CGContextStrokeEllipseInRect(context, rectInset);
    CGContextRestoreGState(context);
}

@end