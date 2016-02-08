//
// Created by Dmitry Korotchenkov on 08.08.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMPointPlotView.h"
#import "YMPlotAreaData.h"
#import "YMPlotPoint.h"
#import "YMPlotPointButton.h"
#import "YMPlotLine.h"
#import "YMPlotXLabel.h"
#import "YMGradientColor.h"
#import "YMPointPlotData.h"


@interface YMPointPlotView ()
@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic, strong) NSArray *lines;
@end

@implementation YMPointPlotView

- (id)initWithFrame:(CGRect)frame plotData:(YMPlotData *)plotData color:(YMGradientColor *)color delegate:(NSObject <YMPlotViewDelegate> *)delegate {
    self = [super initWithFrame:frame plotData:plotData color:color delegate:delegate];
    if (self) {
        NSMutableArray *buttons = [NSMutableArray new];
        NSMutableArray *lines = [NSMutableArray new];
        NSArray *points = [(YMPointPlotData *) plotData points];
        for (NSInteger i = 0; i < points.count; i++) {
            if (i > 0) {
                YMPlotLine *line = [YMPlotLine lineWithColor:color];
                [lines addObject:line];
                [self insertSubview:line atIndex:i - 1];
            }

            YMPlotPointButton *button = [YMPlotPointButton buttonWithPoint:[points objectAtIndex:i] innerColor:[self bgColor] outterColor:color.startColor];
            [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
            [self addSubview:button];

        }
        self.buttons = [NSArray arrayWithArray:buttons];
        self.lines = [NSArray arrayWithArray:lines];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.plotData) {

        CGRect rectForPlot = [self rectForPlot:rect];
        NSArray *points = [(YMPointPlotData *) self.plotData points];
        YMPlotAreaData *areaData = self.plotData.areaData;
        CGFloat kX = [areaData kX:rectForPlot];
        CGFloat kY = [areaData kY:rectForPlot];
        CGFloat zeroSpaceX = [areaData zeroSpaceX:rectForPlot];
        CGFloat zeroSpaceY = [areaData zeroSpaceY:rectForPlot];

        // draw plot lines
        YMPlotPoint *previousPoint;
        for (NSUInteger i = 0; i < points.count; i++) {
            YMPlotPoint *point = points[i];
            if (i == 0) {
                previousPoint = point;
            } else {
                YMPlotPoint *currentPoint = points[i];
                CGFloat startX = rectForPlot.origin.x + previousPoint.x * kX + zeroSpaceX;
                CGFloat startY = rectForPlot.origin.y + (rectForPlot.size.height - previousPoint.y * kY - zeroSpaceY);
                CGFloat endX = rectForPlot.origin.x + currentPoint.x * kX + zeroSpaceX;
                CGFloat endY = rectForPlot.origin.y + (rectForPlot.size.height - currentPoint.y * kY - zeroSpaceY);
                YMPlotLine *line = [self.lines objectAtIndex:i - 1];
                [line setStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX, endY)];
                previousPoint = currentPoint;
            }
        }

        // draw plot points
        for (NSUInteger i = 0; i < points.count; i++) {
            YMPlotPoint *point = points[i];
            CGFloat radius = 15;
            CGFloat x = rectForPlot.origin.x + point.x * kX + zeroSpaceX;
            CGFloat y = rectForPlot.origin.y + (rectForPlot.size.height - point.y * kY - zeroSpaceY);
            YMPlotPointButton *button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(x - radius, y - radius, radius * 2, radius * 2);
        }

    }

    if (self.needUpdateToSelectedInterval) {
        [self updateSelectionForInterval:self.selectedInterval];
        self.needUpdateToSelectedInterval = NO;
    }
}

- (void)tapButton:(YMPlotPointButton *)selectedButton {
    selectedButton.selected = !selectedButton.selected;
    NSInteger currentButtonIndex = [self.buttons indexOfObject:selectedButton];
    NSInteger firstSelectedIndex = NSNotFound;
    NSInteger lastSelectedIndex = NSNotFound;
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        YMPlotPointButton *button = [self.buttons objectAtIndex:i];
        if (button.selected) {
            if (firstSelectedIndex == NSNotFound) {
                firstSelectedIndex = i;
            } else {
                lastSelectedIndex = i;
            }
        }
    }
    NSUInteger mode = [self modeForInterval:YMIntervalMake(firstSelectedIndex, lastSelectedIndex)];

    if (mode == 2 && currentButtonIndex > firstSelectedIndex && currentButtonIndex < lastSelectedIndex) {
        lastSelectedIndex = currentButtonIndex;
    }

    [self updateSelectionForInterval:YMIntervalMake(firstSelectedIndex, lastSelectedIndex)];

    if (mode == 0) {
        [self.delegate didSelectInterval:YMIntervalMake(NSNotFound, NSNotFound)];
    } else {
        CGFloat firstValue = firstSelectedIndex == NSNotFound ? NSNotFound : [self xValueForButtonIndex:(NSUInteger) firstSelectedIndex];
        if (mode == 1) {
            [self.delegate didSelectInterval:YMIntervalMake(firstValue, firstValue)];
        } else {
            CGFloat lastValue = lastSelectedIndex == NSNotFound ? NSNotFound : [self xValueForButtonIndex:(NSUInteger) lastSelectedIndex];
            [self.delegate didSelectInterval:YMIntervalMake(firstValue, lastValue)];
        }
    }

}

- (void)updateSelectionForInterval:(YMInterval)interval {
    NSUInteger mode = [self modeForInterval:interval];
    NSUInteger firstSelectedIndex = (NSUInteger) interval.intervalStart;
    NSUInteger lastSelectedIndex = (NSUInteger) interval.intervalEnd;
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        YMPlotPointButton *button = [self.buttons objectAtIndex:i];
        if (i < self.buttons.count - 1) {
            YMPlotLine *line = [self.lines objectAtIndex:i];
            if (mode < 2) {
                button.selection = i == firstSelectedIndex ? YMPlotPointButtonSelectionBig : YMPlotPointButtonSelectionNone;
                line.selected = NO;
            } else {
                if (i == firstSelectedIndex || i == lastSelectedIndex) {
                    button.selection = YMPlotPointButtonSelectionBig;
                } else {
                    button.selection = (i > firstSelectedIndex && i < lastSelectedIndex) ? YMPlotPointButtonSelectionSmall : YMPlotPointButtonSelectionNone;
                }
                line.selected = (i >= firstSelectedIndex && i < lastSelectedIndex);
            }
        } else {
            button.selection = (i == lastSelectedIndex) || (i == firstSelectedIndex) ? YMPlotPointButtonSelectionBig : YMPlotPointButtonSelectionNone;
        }
    }
    for (YMPlotXLabel *xLabelView in self.xLabels) {
        if (mode == 0) {
            xLabelView.selected = NO;
            [xLabelView showArrow:NO];
        } else {
            CGFloat firstValue = [self xValueForButtonIndex:firstSelectedIndex];
            if (mode == 1) {
                xLabelView.selected = xLabelView.value == firstValue;
                [xLabelView showArrow:xLabelView.selected];
            } else {
                CGFloat lastValue = [self xValueForButtonIndex:lastSelectedIndex];
                xLabelView.selected = xLabelView.value >= firstValue && xLabelView.value <= lastValue;
                [xLabelView showArrow:((xLabelView.value == firstSelectedIndex) || (xLabelView.value == lastSelectedIndex))];
            }
        }
    }
}

- (CGFloat)xValueForButtonIndex:(NSUInteger)index {
    return [(YMPlotPointButton *) [self.buttons objectAtIndex:index] point].x;
}

@end