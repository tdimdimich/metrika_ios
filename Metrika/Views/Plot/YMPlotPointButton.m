//
// Created by Dmitry Korotchenkov on 28.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMPlotPointButton.h"
#import "YMPlotPoint.h"


@interface YMPlotPointButton ()
@property(nonatomic, strong) UIColor *innerColor;
@property(nonatomic, strong) UIColor *outterColor;
@end

@implementation YMPlotPointButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selection = YMPlotPointButtonSelectionNone;
    }

    return self;
}


+ (YMPlotPointButton *)buttonWithPoint:(YMPlotPoint *)point innerColor:(UIColor *)innerColor outterColor:(UIColor *)outterColor {
    YMPlotPointButton *button = [self new];
    button.innerColor = innerColor;
    button.outterColor = outterColor;
    button.point = point;
    return button;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)setSelection:(YMPlotPointButtonSelection)selection {
    _selection = selection;
    [self setSelected:selection != YMPlotPointButtonSelectionNone];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    CGLayerRef pointLayer = nil;
    [self createPointLayer:&pointLayer inContext:context];

    static const CGFloat radius = 6;
    CGRect circleFrame = CGRectMake(rect.size.width / 2 - radius, rect.size.height / 2 - radius, 2 * radius, 2 * radius);
    CGContextDrawLayerInRect(context, circleFrame, pointLayer);
    CGLayerRelease(pointLayer);
    CGContextRestoreGState(context);
}

- (void)createPointLayer:(CGLayerRef *)pLayer inContext:(CGContextRef)context {
    *pLayer = CGLayerCreateWithContext(context, CGSizeMake(24, 24), NULL);
    CGContextRef layerContext = CGLayerGetContext(*pLayer);
    
    if (self.highlighted) {
        if (self.selection == YMPlotPointButtonSelectionBig) {
            CGContextSetFillColorWithColor(layerContext, [self.outterColor CGColor]);
            CGContextFillEllipseInRect(layerContext, CGRectMake(2, 2, 20, 20));
        } else {
            CGContextSetFillColorWithColor(layerContext, [[UIColor whiteColor] CGColor]);
            CGContextFillEllipseInRect(layerContext, CGRectMake(0, 0, 24, 24));
        }
    } else {
        CGRect rect = self.selection == YMPlotPointButtonSelectionBig ? CGRectMake(0, 0, 24, 24) : CGRectMake(2, 2, 20, 20);
        CGColorRef color = self.selection == YMPlotPointButtonSelectionNone ? [self.outterColor CGColor] : [[UIColor whiteColor] CGColor];
        CGContextSetFillColorWithColor(layerContext, color);
        CGContextFillEllipseInRect(layerContext, rect);
    }
    
    CGContextSetFillColorWithColor(layerContext, [self.innerColor CGColor]);
    CGContextFillEllipseInRect(layerContext, CGRectMake(6, 6, 12, 12));
}

@end