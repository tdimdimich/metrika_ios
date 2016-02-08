//
// Created by Dmitry Korotchenkov on 01.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMGradientColor.h"


static NSString *const kStartColorKey = @"startColorEncodeKey";

static NSString *const kEndColorKey = @"endColorEncodeKey";

@implementation YMGradientColor

+(YMGradientColor *)colorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [[self alloc] initWithStartColor:startColor endColor:endColor];
}

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithStartColor:[coder decodeObjectForKey:kStartColorKey] endColor:[coder decodeObjectForKey:kEndColorKey]];
}

- (id)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    self = [super init];
    if (self) {
        self.startColor=startColor;
        self.endColor = endColor;
    }

    return self;
}

- (BOOL)isEqualToColor:(YMGradientColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();

    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *retColor = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return retColor;
        } else {
            return color;
        }
    };

    UIColor *selfColor = convertColorToRGBSpace(self.startColor);
    UIColor *otherUIColor = convertColorToRGBSpace(otherColor.startColor);
    CGColorSpaceRelease(colorSpaceRGB);

    return [selfColor isEqual:otherUIColor];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.startColor forKey:kStartColorKey];
    [coder encodeObject:self.endColor forKey:kEndColorKey];
}

@end