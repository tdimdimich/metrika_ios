//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMColsPlotView.h"
#import "YMPlotData.h"
#import "YMGradientColor.h"
#import "YMColsPlotData.h"
#import "YMColGroup.h"
#import "YMColButton.h"
#import "YMColButtonView.h"
#import "YMPointPlotData.h"
#import "YMPlotXLabel.h"
#import "YMPointPlotView.h"
#import "NSArray+BlocksKit.h"


@interface YMColsPlotView ()
@property(nonatomic, strong) NSMutableArray *cols;
@end

@implementation YMColsPlotView

- (id)initWithFrame:(CGRect)frame plotData:(YMPlotData *)plotData color:(YMGradientColor *)color delegate:(NSObject <YMPlotViewDelegate> *)delegate {
    self = [super initWithFrame:frame plotData:plotData color:color delegate:delegate];
    if (self) {
        YMColsPlotData *colsPlotData = (YMColsPlotData *) plotData;
        NSMutableArray *cols = [NSMutableArray new];
        for (YMColGroup *group in colsPlotData.colGroups) {
            YMColButton *button = [YMColButton buttonWithGroup:group color:color];
            [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            [cols addObject:button];
            [self addSubview:button];
        }
        self.cols = cols;
    }

    return self;
}

- (void)tapButton:(YMColButton *)selectedButton {
    selectedButton.selected = !selectedButton.selected;
    NSInteger currentButtonIndex = [self.cols indexOfObject:selectedButton];
    NSInteger firstSelectedIndex = NSNotFound;
    NSInteger lastSelectedIndex = NSNotFound;
    for (NSUInteger i = 0; i < self.cols.count; i++) {
        YMColButton *button = [self.cols objectAtIndex:i];
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
    for (NSUInteger i = 0; i < self.cols.count; i++) {
        YMColButton *button = [self.cols objectAtIndex:i];
        if (mode < 2) {
            button.selected = i == interval.intervalStart;
        } else {
            button.selected = (i >= interval.intervalStart && i <= interval.intervalEnd);
        }
    }
    for (YMPlotXLabel *xLabelView in self.xLabels) {
        if (mode == 0) {
            xLabelView.selected = NO;
            [xLabelView showArrow:NO];
        } else if (mode == 1) {
            xLabelView.selected = xLabelView.value == [self xValueForButtonIndex:(NSUInteger) interval.intervalStart];
            [xLabelView showArrow:xLabelView.selected];
        } else {
            CGFloat firstSelectedXValue = [self xValueForButtonIndex:(NSUInteger) interval.intervalStart];
            CGFloat lastSelectedXValue = [self xValueForButtonIndex:(NSUInteger) interval.intervalEnd];
            xLabelView.selected = xLabelView.value >= firstSelectedXValue && xLabelView.value <= lastSelectedXValue;
            [xLabelView showArrow:((xLabelView.value == interval.intervalStart) || (xLabelView.value == interval.intervalEnd))];
        }
    }
}

- (CGFloat)xValueForButtonIndex:(NSUInteger)index {
    return [[(YMColButton *) [self.cols objectAtIndex:(NSUInteger) index] colView] group].groupXValue;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGRect rectForPlot = [self rectForPlot:rect];
    YMPlotAreaData *areaData = self.plotData.areaData;
    CGFloat kX = [areaData kX:rectForPlot];
    CGFloat kY = [areaData kY:rectForPlot];
    CGFloat zeroSpaceX = [areaData zeroSpaceX:rectForPlot];
    CGFloat zeroSpaceY = [areaData zeroSpaceY:rectForPlot];

    CGFloat colWidth = (1 * kX) * 0.8;

    for (YMColButton *button in self.cols) {
        CGFloat colHeight = button.colView.group.maxYValue * kY + zeroSpaceY;
        CGFloat x = rectForPlot.origin.x + button.colView.group.groupXValue * kX - colWidth / 2 + zeroSpaceX;
        CGFloat y = rectForPlot.size.height - colHeight;
        [button setFrame:CGRectMake(x, rectForPlot.origin.y, colWidth, rectForPlot.size.height)];
        [button.colView setFrame:CGRectMake(0, y, colWidth, colHeight)];
    }

    if (self.needUpdateToSelectedInterval) {
        [self updateSelectionForInterval:self.selectedInterval];
        self.needUpdateToSelectedInterval = NO;
    }
}


@end