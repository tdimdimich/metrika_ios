//
// File: UIColor+YMAdditions.m
// Project: Metrika
//
// Created by dkorneev on 10/4/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "UIColor+YMAdditions.h"


@implementation UIColor (YMAdditions)

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();

    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *retColor = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return retColor;
        } else
            return color;
    };

    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);

    return [selfColor isEqual:otherColor];
}

@end