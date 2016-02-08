//
// Created by Dmitry Korotchenkov on 28.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMPlotLine.h"
#import "YMGradientColor.h"


@interface YMPlotLine ()
@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGPoint endPoint;
@property(nonatomic, strong) YMGradientColor *color;
@end

@implementation YMPlotLine

+(YMPlotLine *)lineWithColor:(YMGradientColor *)color {
    return [[YMPlotLine alloc] initWithColor:color];
}

- (id)initWithColor:(YMGradientColor *)color {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.color = color;
    }

    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}


- (void)setStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat minX = MIN(startPoint.x, endPoint.x);
    CGFloat minY = MIN(startPoint.y, endPoint.y);
    self.frame = CGRectMake(minX - 5, minY - 5, ABS(endPoint.x - startPoint.x) + 10, ABS(endPoint.y - startPoint.y) + 10);
    self.startPoint = CGPointMake(startPoint.x - minX + 5, startPoint.y - minY + 5);
    self.endPoint = CGPointMake(endPoint.x - minX + 5, endPoint.y - minY + 5);
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    [self drawLine:context start:self.startPoint
               end:self.endPoint width:5];
    CGContextRestoreGState(context);
}


- (void)drawLine:(CGContextRef)context start:(CGPoint)start end:(CGPoint)end width:(CGFloat)width {

    double halfWidth = width / 2;

    double slope, cosy, siny;

    slope = atan2((start.y - end.y), (start.x - end.x));
    cosy = cos(slope);
    siny = sin(slope);


    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};

    UIColor *startColor = self.color.startColor;
    UIColor *endColor = self.color.endColor;
    if (self.selected) {
        startColor = [DKUtils colorWithRed:200 green:200 blue:200];
        endColor = [DKUtils colorWithRed:255 green:255 blue:255];
    }
    CGFloat const *startComponents = CGColorGetComponents([startColor CGColor]);
    CGFloat const *endComponents = CGColorGetComponents([endColor CGColor]);

    CGFloat components[8] = {startComponents[0], startComponents[1], startComponents[2], startComponents[3],
            endComponents[0], endComponents[1], endComponents[2], endComponents[3]
    };

    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);

    CGContextMoveToPoint(context, start.x - halfWidth * siny, start.y + halfWidth * cosy);
    CGContextAddLineToPoint(context, end.x - halfWidth * siny, end.y + halfWidth * cosy);
    CGContextAddLineToPoint(context, end.x + halfWidth * siny, end.y - halfWidth * cosy);
    CGContextAddLineToPoint(context, start.x + halfWidth * siny, start.y - halfWidth * cosy);
    CGContextAddLineToPoint(context, start.x - halfWidth * siny, start.y + halfWidth * cosy);
    CGContextClip(context);

    CGContextDrawLinearGradient(context, myGradient, start, end, 0);
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
}

@end