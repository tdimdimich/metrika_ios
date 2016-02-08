//
// Created by Dmitry Korotchenkov on 30.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMCircleColorButton.h"
#import "YMGradientColor.h"

@implementation YMCircleColorButton

+ (YMCircleColorButton *)buttonWithCenterPosition:(CGPoint)centerPosition color:(UIColor *)color {
    CGRect frame = CGRectMake(centerPosition.x - kCircleColorButtonDiameter / 2, centerPosition.y - kCircleColorButtonDiameter / 2, kCircleColorButtonDiameter, kCircleColorButtonDiameter);
    return [[self alloc] initWithFrame:frame color:color];
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        [self addTarget:self action:@selector(didChangeState:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}


- (void)didChangeState:(UIButton *)didChangeState {
    self.selected = !self.selected;
}

- (void)drawRect:(CGRect)rect {
    static UIColor *selectedColor = nil;
    if (!selectedColor) {
        selectedColor = [DKUtils colorWithRed:229 green:229 blue:229];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);

    if (self.selected) {
        CGContextAddEllipseInRect(context, rect);
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        CGContextFillEllipseInRect(context, rect);
    }

    int offset = (kCircleColorButtonDiameter - kCircleColorButtonInnerDiameter) / 2;
    CGRect innerRect = CGRectMake(offset, offset, kCircleColorButtonInnerDiameter, kCircleColorButtonInnerDiameter);
    CGContextAddEllipseInRect(context, innerRect);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillEllipseInRect(context, innerRect);
    CGContextRestoreGState(context);
}


@end