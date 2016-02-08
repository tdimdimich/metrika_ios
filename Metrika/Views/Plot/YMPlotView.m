//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMPlotView.h"
#import "YMPointPlotView.h"
#import "YMPointPlotData.h"
#import "YMPlotAreaData.h"
#import "YMGradientColor.h"
#import "YMPlotXLabel.h"
#import "YMPlotData.h"

static const int xLabelsViewHeight = 28;

@implementation YMPlotView

- (id)initWithFrame:(CGRect)frame plotData:(YMPlotData *)plotData color:(YMGradientColor *)color delegate:(NSObject <YMPlotViewDelegate> *)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.plotData = plotData;
        self.delegate = delegate;
    }

    return self;
}

- (void)setSelectedInterval:(YMInterval)interval {
    _selectedInterval = interval;
    self.needUpdateToSelectedInterval = YES;
}

- (NSUInteger)modeForInterval:(YMInterval)interval {
    NSUInteger mode = 0;
    if (interval.intervalStart != NSNotFound) {
        if (interval.intervalEnd != NSNotFound) {
            mode = 2;
        } else {
            mode = 1;
        }
    }
    return mode;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.plotData) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);
        CGContextSetFillColorWithColor(context, [[self bgColor] CGColor]);
        CGContextFillRect(context, rect);

        CGRect rectForPlot = [self rectForPlot:rect];

        // draw plot area

        [self drawGrid:context rect:rect rectForPlot:rectForPlot];

    }
}

- (void)drawGrid:(CGContextRef)context rect:(CGRect)rect rectForPlot:(CGRect)rectForPlot {
    CGContextSaveGState(context);

    // set color for labels
    CGContextSetStrokeColorWithColor(context, [[DKUtils colorWithRed:165 green:165 blue:165] CGColor]);
    CGContextSetFillColorWithColor(context, [[DKUtils colorWithRed:165 green:165 blue:165] CGColor]);
    CGContextSetLineWidth(context, 1);
    CGMutablePathRef path = CGPathCreateMutable();

    YMPlotAreaData *areaData = self.plotData.areaData;
    CGFloat kX = [areaData kX:rectForPlot];
    CGFloat kY = [areaData kY:rectForPlot];
    CGFloat zeroSpaceX = [areaData zeroSpaceX:rectForPlot];
    CGFloat zeroSpaceY = [areaData zeroSpaceY:rectForPlot];

    CGFloat yValue;

    CGFloat spaceY = areaData.startGridPoint.y;
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:9];
    }
    do {
        CGFloat y = spaceY;
        yValue = rectForPlot.origin.y + (rectForPlot.size.height - y * kY - zeroSpaceY);
        CGPathMoveToPoint(path, NULL, rectForPlot.origin.x, yValue);
        CGPathAddLineToPoint(path, NULL, rectForPlot.origin.x + rectForPlot.size.width, yValue);
        spaceY = spaceY + areaData.gridYSpace;

        NSString *stringValue;
        if (self.delegate && [self.delegate respondsToSelector:@selector(plotView:titleForYValue:)]) {
            stringValue = [self.delegate plotView:self titleForYValue:y];
        } else {
            if (roundf(y) == y) {
                stringValue = [NSString stringWithFormat:@"%.0f", y];
            } else {
                stringValue = [NSString stringWithFormat:@"%.2f", y];
            }
        }
        CGSize size = [stringValue sizeWithFont:font];
        [stringValue drawAtPoint:CGPointMake(CGRectGetMaxX(rectForPlot) - size.width - 4, yValue + 4) withFont:font];

    } while (spaceY <= areaData.endGridPoint.y);

    CGFloat xValue;
    CGFloat spaceX = areaData.startGridPoint.x;
    NSUInteger i = 0;
    NSMutableArray *xLabels;
    if (!self.xLabels) {
        xLabels = [NSMutableArray new];
    } else {
        xLabels = self.xLabels;
    }
    do {
        CGFloat x = spaceX;
        xValue = rectForPlot.origin.x + x * kX + zeroSpaceX;
        CGPathMoveToPoint(path, NULL, xValue, rectForPlot.origin.y);
        CGPathAddLineToPoint(path, NULL, xValue, rectForPlot.origin.y + rectForPlot.size.height);
        spaceX = spaceX + areaData.gridXSpace;

        YMPlotXLabel *labelView;
        if (!self.xLabels) {
            NSArray *titles;
            if (self.delegate && [self.delegate respondsToSelector:@selector(plotView:titlesForXValue:)]) {
                titles = [self.delegate plotView:self titlesForXValue:x];
            } else {
                titles = @[[NSString stringWithFormat:@"%.0f", x]];
            }

            if (titles.count > 1) {
                labelView = [[YMPlotXLabel alloc] initWithFirstLineText:[titles objectAtIndex:0] secondLineText:[titles objectAtIndex:1] value:x];
            } else {
                labelView = [[YMPlotXLabel alloc] initWithFirstLineText:[titles objectAtIndex:0] secondLineText:nil value:x];
            }
            [self addSubview:labelView];
            [xLabels addObject:labelView];
        } else {
            labelView = [self.xLabels objectAtIndex:i];
        }
        labelView.bottom = rect.size.height;
        labelView.centerX = xValue;
        i++;
    } while (spaceX <= areaData.endGridPoint.x);
    self.xLabels = xLabels;

    // set color fo grid
    CGContextSetStrokeColorWithColor(context, [[DKUtils colorWithRed:96 green:96 blue:96] CGColor]);
    CGContextSetFillColorWithColor(context, [[DKUtils colorWithRed:96 green:96 blue:96] CGColor]);
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
}

- (CGRect)rectForPlot:(CGRect)rect {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - xLabelsViewHeight);
}

- (UIColor *)bgColor {
    return [DKUtils colorWithRed:71 green:71 blue:73];
}


@end