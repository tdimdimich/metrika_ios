//
// Created by Dmitry Korotchenkov on 20/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMColButtonView.h"
#import "YMColGroup.h"
#import "YMGradientColor.h"

@interface YMColButtonView ()
@property(nonatomic, strong) YMGradientColor *color;
@property(nonatomic) BOOL highlighted;
@property(nonatomic) BOOL selected;
@end

@implementation YMColButtonView

+ (YMColButtonView *)buttonWithGroup:(YMColGroup *)group color:(YMGradientColor *)color {
    return [[self alloc] initWithGroup:group color:color];
}

- (id)initWithGroup:(YMColGroup *)group color:(YMGradientColor *)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.group = group;
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }

    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);

    CGFloat (^reverseValue)(CGFloat) = ^(CGFloat value) {
        return rect.size.height - value;
    };

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, reverseValue(0));
    CGFloat colWidth = rect.size.width / self.group.groupValues.count;
    CGFloat kY = self.group.maxYValue > 0 ? rect.size.height / self.group.maxYValue : 0;
    for (NSUInteger i = 0; i < self.group.groupValues.count; i++) {
        NSNumber *number = [self.group.groupValues objectAtIndex:i];
        CGPathAddLineToPoint(path, NULL, i * colWidth, reverseValue(number.floatValue * kY));
        CGPathAddLineToPoint(path, NULL, (i + 1) * colWidth, reverseValue(number.floatValue * kY));
    }
    CGPathAddLineToPoint(path, NULL, rect.size.width, reverseValue(0));
    CGPathAddLineToPoint(path, NULL, 0, reverseValue(0));

    if ((self.highlighted && !self.selected) || (!self.highlighted && self.selected)) {
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    } else {
        CGContextSetFillColorWithColor(context, [self.color.startColor CGColor]);
    }
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);


    CGContextRestoreGState(context);

}
@end