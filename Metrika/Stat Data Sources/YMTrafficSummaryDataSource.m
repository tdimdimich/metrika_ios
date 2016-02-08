//
// Created by Dmitry Korotchenkov on 12/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMTrafficSummaryDataSource.h"
#import "YMPointPlotData.h"
#import "NSArray+BlocksKit.h"
#import "YMTrafficSummary.h"
#import "YMPlotPoint.h"
#import "NSDate+YMAdditions.h"
#import "NSDate+DKAdditions.h"
#import "YMColGroup.h"
#import "YMColsPlotData.h"
#import "YMAbstractInfoElementCell.h"
#import "YMElementModel.h"
#import "YMAppSettings.h"
#import "YMGradientColor.h"
#import "YMDateRange.h"
#import "YMDetailedElementModel.h"
#import "YMGraphInfoElementCell.h"
#import "YMValueTypeStringFormat.h"

typedef enum {
    YMTrafficSummaryTypeVisits = 0,
    YMTrafficSummaryTypePageViews,
    YMTrafficSummaryTypeVisitors,
    YMTrafficSummaryTypeVisitorsNew,
    YMTrafficSummaryTypeDenial,
    YMTrafficSummaryTypeDepth,
    YMTrafficSummaryTypeVisitTime,
} YMTrafficSummaryType;

static const int kMaxRangesCount = 6;

@interface YMTrafficSummaryDataSource ()
@property(nonatomic, strong) NSDate *dateStart;
@property(nonatomic, strong) NSDate *dateEnd;
@property(nonatomic, strong) NSArray *contentByDateRange;

@property(nonatomic, strong) NSArray *dateRanges;
@property(nonatomic, strong) NSMutableArray *colsPlotDataArray;
@property(nonatomic, strong) NSMutableArray *pointsPlotDataArray;

@property(nonatomic, strong) NSArray *elements;
@property(nonatomic) NSUInteger selectedRowIndex;
@property(nonatomic, strong) NSArray *elementsByDateRange;
@end

@implementation YMTrafficSummaryDataSource

- (id)initWithTrafficContent:(NSArray *)trafficContent dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self = [super init];
    if (self) {

        self.selectedTypeIndex = 0;
        self.selectedRowIndex = NSNotFound;
        self.selectedInterval = YMIntervalMake(NSNotFound, NSNotFound);

        NSMutableArray *array = [NSMutableArray new];
        for (NSUInteger i = 0; i < self.typeTitles.count; i++) {
            [array addObject:[NSNull null]];
        }
        self.colsPlotDataArray = [NSMutableArray arrayWithArray:array];
        self.pointsPlotDataArray = [NSMutableArray arrayWithArray:array];

        [self setupData:trafficContent dateStart:dateStart dateEnd:dateEnd];

    }

    return self;
}

- (void)setupData:(NSArray *)trafficContent dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    self.dateStart = [dateStart beginOfDay];
    self.dateEnd = [dateEnd beginOfDay];


    // создаем массив интервалов
    NSUInteger days = (NSUInteger) [self.dateStart daysToDate:self.dateEnd] + 1;
    days = days ?: 1;
    NSUInteger count = days < kMaxRangesCount ? days : kMaxRangesCount;
    NSUInteger step = days / count;
    NSMutableArray *data = [NSMutableArray new];
    NSMutableArray *dateRanges = [NSMutableArray new];
    NSMutableArray *elementsByDateRange = [NSMutableArray new];
    for (NSUInteger i = 0; i < count; i++) {
        [data addObject:[NSMutableArray new]];
        NSDate *firstDate = [[self.dateStart beginOfDay] dateByAddingDays:i * step + (i < (days % count) ? i : days % count)];
        NSDate *secondDate;
        if (i == (count - 1)) {
            secondDate = self.dateEnd;
        } else {
            secondDate = [self.dateStart dateByAddingDays:((i + 1) * step + ((i + 1) < (days % count) ? (i + 1) : days % count) - 1)];
        };
        YMDateRange *dateRange = [YMDateRange rangeWithDateStart:firstDate dateEnd:secondDate];

        NSMutableArray *elementsByType = [NSMutableArray new];
        for (NSUInteger j = 0; j < self.typeTitles.count; j++) {
            [elementsByType addObject:[YMElementModel modelWithMinDate:dateRange.dateStart maxDate:dateRange.dateStart totalValue:0 minValue:NSNotFound maxValue:NSNotFound]];
        }
        [elementsByDateRange addObject:elementsByType];
        [dateRanges addObject:dateRange];
    }
    self.dateRanges = [NSArray arrayWithArray:dateRanges];

    for (YMTrafficSummary *traffic in trafficContent) {
        NSUInteger index = [[self dateRanges] indexOfObject:[self rangeForDate:traffic.date]];

        NSMutableArray *childData = [data objectAtIndex:index];
        [childData addObject:traffic];

        NSArray *elementsByType = elementsByDateRange[index];
        for (NSUInteger i = 0; i < elementsByType.count; i++) {
            YMElementModel *element = elementsByType[i];
            CGFloat value = [self trafficSummary:traffic valueForIndex:i].floatValue;

            if (value < element.minValue || element.minValue == NSNotFound) {
                element.minValue = value;
                element.minDate = traffic.date;
            }
            if (value > element.maxValue || element.maxValue == NSNotFound) {
                element.maxValue = value;
                element.maxDate = traffic.date;
            }
            if (i == YMTrafficSummaryTypeDenial || i == YMTrafficSummaryTypeVisitTime) {
                // для подсчета среднего значения нужно умножать на число посетителей в данный день,
                // а затем разделить на общее число посетителей за временной интервал (см ниже)
                element.totalValue += value * [self trafficSummary:traffic valueForIndex:YMTrafficSummaryTypeVisitors].floatValue;
            } else {
                element.totalValue += value;
            }
        }
    }

    for (NSUInteger i = 0; i < count; i++) {
        NSMutableArray *childData = data[i];
        childData = [NSMutableArray arrayWithArray:[childData sortedArrayUsingComparator:^NSComparisonResult(YMTrafficSummary *obj1, YMTrafficSummary *obj2) {
            return [obj1.date isLessThan:obj2.date] ? NSOrderedAscending : NSOrderedDescending;
        }]];
        data[i] = childData;

        NSMutableArray *elementsByType = elementsByDateRange[i];
        YMElementModel *elementDenial = elementsByType[YMTrafficSummaryTypeDenial];
        YMElementModel *elementVisitTime = elementsByType[YMTrafficSummaryTypeVisitTime];
        YMElementModel *elementDepth = elementsByType[YMTrafficSummaryTypeDepth];
        YMElementModel *elementVisits = elementsByType[YMTrafficSummaryTypeVisits];
        YMElementModel *elementVisitors = elementsByType[YMTrafficSummaryTypeVisitors];
        YMElementModel *elementPageViews = elementsByType[YMTrafficSummaryTypePageViews];
        elementDepth.totalValue = elementPageViews.totalValue / (elementVisits.totalValue ?: 1); // нельзя делить на ноль

        // сумму средних значений помноженых на число посетителей в день (см выше)
        // делим на общее число посетителей для временного интервала
        if (elementVisitors.totalValue > 0) {
            elementDenial.totalValue = elementDenial.totalValue / elementVisitors.totalValue;
            elementVisitTime.totalValue = elementVisitTime.totalValue / elementVisitors.totalValue;
        }


    }
    self.elementsByDateRange = elementsByDateRange;
    self.contentByDateRange = [NSArray arrayWithArray:data];
}

- (void)setElementsByDateRange:(NSArray *)elementsByDateRange {
    _elementsByDateRange = elementsByDateRange;
}


- (NSArray *)typeTitles {
    static NSArray *titles;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        titles = @[
                NSLocalizedString(@"Picker-Visits", nil),
                NSLocalizedString(@"Picker-Views", nil),
                NSLocalizedString(@"Picker-Visitors", nil),
                NSLocalizedString(@"Picker-New", nil),
                NSLocalizedString(@"Picker-Failure", nil),
                NSLocalizedString(@"Picker-Deepness", nil),
                NSLocalizedString(@"Picker-Time", nil),
        ];
    });
    return titles;
}

- (NSNumber *)trafficSummary:(YMTrafficSummary *)summary valueForIndex:(NSUInteger)index {
    if (index == YMTrafficSummaryTypeVisits) {
        return summary.visits;
    } else if (index == YMTrafficSummaryTypePageViews) {
        return summary.pageViews;
    } else if (index == YMTrafficSummaryTypeVisitors) {
        return summary.visitors;
    } else if (index == YMTrafficSummaryTypeVisitorsNew) {
        return summary.visitorsNew;
    } else if (index == YMTrafficSummaryTypeDenial) {
        return summary.denial;
    } else if (index == YMTrafficSummaryTypeDepth) {
        return summary.depth;
    } else if (index == YMTrafficSummaryTypeVisitTime) {
        return summary.visitTime;
    } else {
        return @0;
    }
}

- (NSUInteger)lengthForSelectedInterval {
    if (self.selectedInterval.intervalStart == NSNotFound || self.selectedInterval.intervalEnd == NSNotFound)
        return self.dateRanges.count;
    else if (self.selectedInterval.intervalStart == self.selectedInterval.intervalEnd)
        return 1;
    else
        return (NSUInteger) (self.selectedInterval.intervalEnd - self.selectedInterval.intervalStart) + 1;
}

#pragma mark titles for plot grid and plot selections

- (void)didSelectInterval:(YMInterval)interval {
    self.selectedInterval = interval;
}

- (NSArray *)titlesForXValue:(CGFloat)x {
    YMDateRange *range = [self.dateRanges objectAtIndex:(NSUInteger) x];
    if (range.lengthIdDays > 1) {
        return @[[NSString stringWithFormat:@"%@", [range.dateStart stringWithFormat:@"dd.MM"]], [NSString stringWithFormat:@"%@", [range.dateEnd stringWithFormat:@"dd.MM"]]];
    } else {
        return @[[NSString stringWithFormat:@"%@", [range.dateStart stringWithFormat:@"dd.MM"]]];
    }
}

#pragma mark point data methods

- (YMPointPlotData *)pointPlotData {
    NSUInteger index = self.selectedTypeIndex;
    id plotData = [self.pointsPlotDataArray objectAtIndex:index];
    if ([plotData isKindOfClass:[NSNull class]]) {
        plotData = [self pointsDataForIndex:index];
        [self.pointsPlotDataArray replaceObjectAtIndex:index withObject:plotData];
    }

    return plotData;
}

- (YMPointPlotData *)pointsDataForIndex:(NSUInteger)index {

    NSMutableArray *points = [NSMutableArray new];
    CGFloat minValue = NSNotFound;
    CGFloat maxValue = NSNotFound;
    for (NSUInteger i = 0; i < self.elementsByDateRange.count; i++) {
        YMElementModel *currentElement = self.elementsByDateRange[i][index];

        if ((minValue == NSNotFound) || ((minValue != NSNotFound) && currentElement.totalValue < minValue)) {
            minValue = currentElement.totalValue;
        }
        if ((maxValue == NSNotFound) || ((maxValue != NSNotFound) && currentElement.totalValue > maxValue)) {
            maxValue = currentElement.totalValue;
        }
        [points addObject:[YMPlotPoint pointWithX:i y:currentElement.totalValue]];
    }

    YMPointPlotData *plotData = [YMPointPlotData new];
    plotData.points = points;
    YMPlotAreaData *areaData = [YMPlotAreaData new];

    maxValue = maxValue ?: 1;
    CGPoint yGrid = [YMUtils calculateGridForMaxValue:maxValue minValue:minValue];
    CGFloat start = yGrid.x;
    CGFloat step = yGrid.y;
    step = step ?: maxValue;

    areaData.startPlotPoint = CGPointMake(-1, start);
    areaData.endPlotPoint = CGPointMake(self.contentByDateRange.count, maxValue + step);
    areaData.startGridPoint = CGPointMake(0, start);
    areaData.endGridPoint = CGPointMake(self.contentByDateRange.count - 1, maxValue + step);
    areaData.gridXSpace = 1;
    areaData.gridYSpace = step;
    plotData.areaData = areaData;
    return plotData;
}
#pragma mark cols data methods

- (YMColsPlotData *)colsPlotData {
    NSUInteger index = self.selectedTypeIndex;
    id plotData = [self.colsPlotDataArray objectAtIndex:index];
    if ([plotData isKindOfClass:[NSNull class]]) {
        plotData = [self colsDataForValue:^NSNumber *(YMTrafficSummary *summary) {
            return [self trafficSummary:summary valueForIndex:index];
        }];
        [self.colsPlotDataArray replaceObjectAtIndex:index withObject:plotData];
    }

    return plotData;
}

- (YMColsPlotData *)colsDataForValue:(NSNumber * (^)(YMTrafficSummary *))block {
    NSMutableArray *cols = [NSMutableArray new];
    __block CGFloat minValue = NSNotFound;
    __block CGFloat maxValue = NSNotFound;
    for (NSUInteger i = 0; i < self.contentByDateRange.count; i++) {
        NSMutableArray *childData = self.contentByDateRange[i];
        YMDateRange *range = self.dateRanges[i];
        NSMutableArray *array = [NSMutableArray new];

        for (NSUInteger d = 0; d < [range lengthIdDays]; d++) {
            [array addObject:[NSNumber numberWithInt:0]];
        }

        [childData bk_each:^(YMTrafficSummary *traffic) {
            array[(NSUInteger) ([range.dateStart daysToDate:traffic.date])] = block(traffic);
            if ((minValue == NSNotFound) || ((minValue != NSNotFound) && block(traffic).floatValue < minValue)) {
                minValue = block(traffic).floatValue;
            }
            if ((maxValue == NSNotFound) || ((maxValue != NSNotFound) && block(traffic).floatValue > maxValue)) {
                maxValue = block(traffic).floatValue;
            }
        }];

        [cols addObject:[YMColGroup groupWithGroupXValue:i groupValues:array]];
    }

    minValue = (minValue == NSNotFound) ? 0 : minValue;
    maxValue = (maxValue == NSNotFound) ? 0 : maxValue;

    YMColsPlotData *colsPlotData = [YMColsPlotData new];
    colsPlotData.colGroups = cols;

    YMPlotAreaData *areaData = [YMPlotAreaData new];

    CGPoint yGrid = [YMUtils calculateGridForMaxValue:maxValue minValue:minValue];
    CGFloat start = 0;
    CGFloat step = 0;
    if (yGrid.y > 0) {
        start = yGrid.x;
        step = yGrid.y;

    } else {
        if (maxValue == minValue) {
            step = maxValue;
        } else {
            step = (maxValue - minValue) / 4.0;
            start = minValue - step > 0 ? minValue - step : 0;
        }
    }

    step = step ?: 1;

    areaData.startPlotPoint = CGPointMake(-1, start);
    areaData.endPlotPoint = CGPointMake(self.contentByDateRange.count, maxValue + step);
    areaData.startGridPoint = CGPointMake(0, start);
    areaData.endGridPoint = CGPointMake(self.contentByDateRange.count - 1, maxValue + step);
    areaData.gridXSpace = 1;
    areaData.gridYSpace = step;
    colsPlotData.areaData = areaData;
    return colsPlotData;
}

#pragma mark table view part

- (YMDateRange *)rangeForDate:(NSDate *)date {
    return [[self dateRanges] bk_match:^BOOL(YMDateRange *range) {
        return ([[date beginOfDay] isMoreThanOrEqual:range.dateStart] && [[date beginOfDay] isLessThanOrEqual:range.dateEnd]);
    }];
}

- (YMElementModel *)modelForCurrentSelectedRangeAndIndex:(NSUInteger)index {
    NSUInteger startRangeIndex = 0;
    NSUInteger endRangeIndex = self.dateRanges.count - 1;
    if (self.selectedInterval.intervalStart != NSNotFound && self.selectedInterval.intervalEnd != NSNotFound) {
        startRangeIndex = (NSUInteger) self.selectedInterval.intervalStart;
        endRangeIndex = (NSUInteger) self.selectedInterval.intervalEnd;
    }
//    YMElementModel *firstModel = [[self.elementsByDateRange objectAtIndex:startRangeIndex] objectAtIndex:index];
    YMElementModel *returnedModel = [YMElementModel modelWithMinDate:nil maxDate:nil totalValue:0 minValue:NSNotFound maxValue:NSNotFound];
    CGFloat totalVisits = 0;
    CGFloat totalPageViews = 0;
    CGFloat totalVisitors = 0;
    for (NSUInteger i = startRangeIndex; i <= endRangeIndex; i++) {
        NSArray *elementsByType = [self.elementsByDateRange objectAtIndex:i];
        YMElementModel *model = [elementsByType objectAtIndex:index];
        if (index == YMTrafficSummaryTypeDepth) {
            YMElementModel *visitsModel = [elementsByType objectAtIndex:YMTrafficSummaryTypeVisits];
            YMElementModel *pageViewsModel = [elementsByType objectAtIndex:YMTrafficSummaryTypePageViews];
            totalVisits += visitsModel.totalValue;
            totalPageViews += pageViewsModel.totalValue;
        }
        if (index == YMTrafficSummaryTypeDenial || index == YMTrafficSummaryTypeVisitTime) {
            YMElementModel *visitorsModel = [elementsByType objectAtIndex:YMTrafficSummaryTypeVisitors];
            totalVisitors += visitorsModel.totalValue;
            returnedModel.totalValue += model.totalValue * visitorsModel.totalValue;
        } else {
            returnedModel.totalValue += model.totalValue;
        }
        if ((model.minValue != NSNotFound) && ((model.minValue < returnedModel.minValue) || returnedModel.minValue == NSNotFound)) {
            returnedModel.minValue = model.minValue;
            returnedModel.minDate = model.minDate;
        }
        if ((model.maxValue != NSNotFound) && ((model.maxValue > returnedModel.maxValue) || returnedModel.maxValue == NSNotFound)) {
            returnedModel.maxValue = model.maxValue;
            returnedModel.maxDate = model.maxDate;
        }
    }
    if (returnedModel.minValue == NSNotFound) {
        returnedModel.minValue = 0;
    }
    if (returnedModel.maxValue == NSNotFound) {
        returnedModel.maxValue = 0;
    }
    totalVisitors = totalVisitors ?: 1;
    totalVisits = totalVisits ?: 1;
    if (index == YMTrafficSummaryTypeDepth) {
        returnedModel.totalValue = totalPageViews / totalVisits;
    }
    if (index == YMTrafficSummaryTypeDenial) {
        returnedModel.totalValue = (returnedModel.totalValue / totalVisitors) * 100;
        returnedModel.totalString = [NSString stringWithFormat:@"%0.0f", returnedModel.totalValue];
        returnedModel.totalType = @"%";
    } else if (index == YMTrafficSummaryTypeVisitTime) {
        YMValueTypeStringFormat *format = [YMValueTypeStringFormat timeFormatFromSeconds:(NSInteger) (returnedModel.totalValue / totalVisitors)];
        returnedModel.totalString = format.value;
        returnedModel.totalType = format.type;
        format = [YMValueTypeStringFormat timeFormatFromSeconds:(NSInteger) returnedModel.maxValue];
        returnedModel.maxValueString = [NSString stringWithFormat:@"%@%@", format.value, format.type];

        format = [YMValueTypeStringFormat timeFormatFromSeconds:(NSInteger) returnedModel.minValue];
        returnedModel.minValueString = [NSString stringWithFormat:@"%@%@", format.value, format.type];
    } else {
        YMValueTypeStringFormat *format = [YMValueTypeStringFormat formatFromFloatValue:returnedModel.totalValue];
        returnedModel.totalString = format.value;
        returnedModel.totalType = format.type;
    }
    return returnedModel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat secondSectionHeight = tableView.height - [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGFloat minHeight = [YMAbstractInfoElementCell closedHeight];
    NSInteger totalCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (self.selectedRowIndex == NSNotFound || [self lengthForSelectedInterval] < 2) {
        if (minHeight * totalCount < secondSectionHeight)
            return secondSectionHeight / totalCount;
        else
            return minHeight;
    } else {
        CGFloat openingCellHeight = [YMAbstractInfoElementCell openedHeightForDetailsCount:[self lengthForSelectedInterval]];
        if (minHeight * (totalCount - 1) < secondSectionHeight - openingCellHeight)
            return (self.selectedRowIndex == indexPath.row) ? openingCellHeight : (secondSectionHeight - openingCellHeight) / (totalCount - 1);
        else
            return (self.selectedRowIndex == indexPath.row) ? openingCellHeight : [YMAbstractInfoElementCell closedHeight];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMGraphInfoElementCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoElementCellID];
    if (!cell) {
        cell = [YMGraphInfoElementCell createCell];
    }
    NSUInteger index;
    if (indexPath.row == 0) {
        index = self.selectedTypeIndex;
    } else if (indexPath.row <= self.selectedTypeIndex) {
        index = (NSUInteger) (indexPath.row - 1);
    } else {
        index = (NSUInteger) indexPath.row;
    }
    NSString *title = [NSString stringWithFormat:@"%@:", self.typeTitles[index]];
    YMElementModel *model = [self modelForCurrentSelectedRangeAndIndex:index];
    UIColor *color = indexPath.row == 0 ? [YMAppSettings selectedCounter].color.startColor : nil;
    cell.arrowButton.hidden = !(self.dateRanges.count > 1 && [self lengthForSelectedInterval] > 1);
    if (indexPath.row == self.selectedRowIndex && [self lengthForSelectedInterval] > 1) {
        [cell fillWithTitle:title model:model color:color detailedModels:[self detailedModelsForIndex:index] separatorColor:[UIColor blackColor]];
    } else {
        if (indexPath.row == self.selectedRowIndex - 1 && indexPath.row != 0 && [self lengthForSelectedInterval] > 1) {
            [cell fillWithTitle:title model:model color:color separatorColor:[UIColor blackColor]];
        } else {
            [cell fillWithTitle:title model:model color:color separatorColor:nil ];
        }
    }
    return cell;
}

- (NSArray *)detailedModelsForIndex:(NSUInteger)index {

    NSMutableArray *models = [NSMutableArray new];
    NSUInteger startIndex = 0;
    NSUInteger endIndex = self.dateRanges.count - 1;
    if (self.selectedInterval.intervalStart != NSNotFound && self.selectedInterval.intervalEnd != NSNotFound) {
        startIndex = (NSUInteger) self.selectedInterval.intervalStart;
        endIndex = (NSUInteger) self.selectedInterval.intervalEnd;
    }

    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        YMDateRange *dateRange = self.dateRanges[i];
        YMElementModel *currentElement = self.elementsByDateRange[i][index];
        CGFloat floatValue = currentElement.totalValue;
        NSString *title = [NSString stringWithFormat:@"%@ - %@", [dateRange.dateStart stringWithFormat:@"dd MMM"], [dateRange.dateEnd stringWithFormat:@"dd MMM"]];
        YMElementModel *element = [self modelForCurrentSelectedRangeAndIndex:index];

        NSString *stringValue = nil;
        NSString *type = nil;
        CGFloat percent;
        if (index == YMTrafficSummaryTypeVisitTime || index == YMTrafficSummaryTypeDenial || index == YMTrafficSummaryTypeDepth) {
            CGFloat maxValue = 0;
            for (NSUInteger j = startIndex; j <= endIndex; j++) {
                YMElementModel *model = self.elementsByDateRange[j][index];
                if (model.totalValue > maxValue) {
                    maxValue = model.totalValue;
                }
            }
            percent = floatValue * 100 / (maxValue ?: 1);
        } else {
            percent = element.totalValue ? (floatValue / element.totalValue * 100) : 0;
        }
        if (index == YMTrafficSummaryTypeDenial) {
            stringValue = [NSString stringWithFormat:@"%0.0f", floatValue * 100];
            type = @"%";
        } else if (index == YMTrafficSummaryTypeVisitTime) {
            YMValueTypeStringFormat *format = [YMValueTypeStringFormat timeFormatFromSeconds:(NSInteger) floatValue];
            stringValue = format.value;
            type = format.type;
        } else {
            YMValueTypeStringFormat *format = [YMValueTypeStringFormat formatFromFloatValue:floatValue];
            stringValue = format.value;
            type = format.type;
        }

        [models addObject:[YMDetailedElementModel modelWithTitle:title value:stringValue valueType:type percent:percent]];
    }

    return [NSArray arrayWithArray:models];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dateRanges.count > 1 && [self lengthForSelectedInterval] > 1) {
        self.selectedRowIndex = (NSUInteger) (self.selectedRowIndex == indexPath.row ? NSNotFound : (NSUInteger) indexPath.row);
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:(NSUInteger) indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}


@end