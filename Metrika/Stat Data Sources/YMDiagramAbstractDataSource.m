//
// Created by Dmitry Korotchenkov on 06/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "YMDiagramAbstractDataSource.h"
#import "YMUtils.h"
#import "YMAppSettings.h"
#import "YMDiagramTableCell.h"
#import "YMAbstractInfoElementCell.h"
#import "YMDetailedElementModel.h"
#import "YMGradientColor.h"
#import "YMDiagramInfoElementCell.h"
#import "YMValueTypeStringFormat.h"
#import "NSString+stripHtml.h"

@implementation YMDiagramAbstractDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.selectedTypeIndex = 0;
        self.selectedRowIndex = NSNotFound;
    }

    return self;
}

// must be overridden
- (NSArray *)typeTitles {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// must be overridden
- (NSString *)titleForData:(id)data {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// must be overridden
- (CGFloat)mainValueForData:(id)data {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

// must be overridden
- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// must be overridden
- (BOOL)isIndexForPercentValue:(NSUInteger)index {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

// must be overridden
- (BOOL)isIndexForTimeValue:(NSUInteger)index {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

// must be overridden
- (BOOL)isIndexForCalculateAverageValue:(NSUInteger)index {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

// must be overridden
- (NSUInteger)indexOfValueForCalculateAverage {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (YMDetailedElementModel *)detailedModelForIndex:(NSUInteger)index typeIndex:(NSUInteger)typeIndex {
    CGFloat total = [self totalValueForIndex:typeIndex];
    id summary = self.data[index];
    NSNumber *value = [self data:summary valueForIndex:typeIndex];
    float percent;
    if ([self isIndexForCalculateAverageValue:typeIndex]) {
        float maxValue = 0;
        for (id currentSummary in self.data) {
            float currentValue = [self data:currentSummary valueForIndex:typeIndex].floatValue;
            if (currentValue > maxValue) {
                maxValue = currentValue;
            }

        }
        percent = maxValue ? (value.floatValue / maxValue * 100) : 0;
    } else {
        percent = total ? (value.floatValue / total * 100) : 0;
    }
    if ([self isIndexForPercentValue:typeIndex]) {
        return [self detailedModelForPercentValue:value title:self.typeTitles[typeIndex]];
    } else if ([self isIndexForTimeValue:typeIndex]) {
        return [self detailedModelForTimeValue:value title:self.typeTitles[typeIndex] percent:percent];
    } else {
        return [self detailedModelForNumericValue:value title:self.typeTitles[typeIndex] percent:percent];
    }
}

- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex {
    __block CGFloat total = 0;
    __block CGFloat totalVisits = 0;
    [self.data bk_each:^(id currentSummary) {
        if ([self isIndexForCalculateAverageValue:typeIndex]) {
            float visits = [self data:currentSummary valueForIndex:self.indexOfValueForCalculateAverage].floatValue;
            totalVisits += visits;
            total += [self data:currentSummary valueForIndex:typeIndex].floatValue * visits;
        } else {
            total += [self data:currentSummary valueForIndex:typeIndex].floatValue;
        }
    }];
    if ([self isIndexForCalculateAverageValue:typeIndex] && totalVisits > 0) {
        total = total / totalVisits;
    }
    return total;
}

- (YMValueTypeStringFormat *)totalValueForSelectedIndex {
    CGFloat total = [self totalValueForIndex:self.selectedTypeIndex];
    if ([self isIndexForPercentValue:self.selectedTypeIndex]) {
        return [YMValueTypeStringFormat formatWithValue:[NSString stringWithFormat:@"%0.0f", total * 100]
                                                   type:@"%"];
    } else if ([self isIndexForTimeValue:self.selectedTypeIndex]) {
        return [YMValueTypeStringFormat timeFormatFromSeconds:(NSInteger) total];
    } else {
        return [YMValueTypeStringFormat formatFromFloatValue:total];
    }
}

- (NSArray *)detailedModelsForIndex:(NSUInteger)index {
    NSMutableArray *models = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.typeTitles.count; i++) {
        [models addObject:[self detailedModelForIndex:index typeIndex:i]];
    }
    return models;
}

- (YMDetailedElementModel *)detailedModelForPercentValue:(NSNumber *)value title:(NSString *)title {
    return [YMDetailedElementModel modelWithTitle:title
                                            value:[NSString stringWithFormat:@"%0.0f", value.floatValue * 100]
                                        valueType:@"%"
                                          percent:value.floatValue * 100];
}

- (YMDetailedElementModel *)detailedModelForTimeValue:(NSNumber *)value title:(NSString *)title percent:(CGFloat)percent {
    YMValueTypeStringFormat *format = [YMValueTypeStringFormat timeFormatFromSeconds:value.integerValue];
    return [YMDetailedElementModel modelWithTitle:title
                                            value:format.value
                                        valueType:format.type
                                          percent:percent];
}

- (YMDetailedElementModel *)detailedModelForNumericValue:(NSNumber *)value title:(NSString *)title percent:(CGFloat)percent {
    YMValueTypeStringFormat *format = [YMValueTypeStringFormat formatFromFloatValue:value.floatValue];
    return [YMDetailedElementModel modelWithTitle:title
                                            value:format.value
                                        valueType:format.type
                                          percent:percent];
}

#pragma mark UITableView dataSource, delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section isLandscape:(BOOL)isLandscape {
    if (isLandscape && section != 0)
        return 0;
    else
        return self.data.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isLandscape:(BOOL)isLandscape {
    NSInteger totalCount = self.data.count;
    if (isLandscape) {
        CGFloat cellHeight = tableView.height / totalCount;
        if (cellHeight > kDiagramTableCellLandscapeMinHeight)
            return cellHeight;

        else return kDiagramTableCellLandscapeMinHeight;

    } else {
        if (indexPath.section == 0) {
            return kDiagramTableCellPortraitHeight;

        } else {
            CGFloat secondSectionHeight = tableView.height - kDiagramTableCellPortraitHeight * totalCount;
            CGFloat minHeight = [YMAbstractInfoElementCell closedHeight];

            if (self.selectedRowIndex == NSNotFound) {
                return minHeight;

            } else {
                CGFloat openedCellHeight = [YMAbstractInfoElementCell openedHeightForDetailsCount:[self.typeTitles count]];
                return (self.selectedRowIndex == indexPath.row) ? openedCellHeight : minHeight;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isLandscape:(BOOL)isLandscape {
    NSString *title = [self titleForData:self.data[(NSUInteger) indexPath.row]];
    title = [title stripHtml];
    if (indexPath.section == 0) {
        YMDiagramTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDiagramTableCellID];
        if (!cell) {
            cell = [YMDiagramTableCell createCell];
        }
        YMDetailedElementModel *detailedModel = [self detailedModelForIndex:(NSUInteger) indexPath.row typeIndex:self.selectedTypeIndex];
        [cell fillWithTitle:title progerss:detailedModel.percent color:[YMAppSettings selectedCounter].color.startColor isLandscape:isLandscape];
        return cell;
    } else {
        YMDiagramInfoElementCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoElementCellID];
        if (!cell) {
            cell = [YMDiagramInfoElementCell createCell];
        }

        title = [NSString stringWithFormat:@"%@:", title];
        CGFloat value = [self mainValueForData:self.data[(NSUInteger) indexPath.row]];

        UIColor *color = indexPath.row == 0 ? [YMAppSettings selectedCounter].color.startColor : nil;
        if (indexPath.row == self.selectedRowIndex) {
            [cell fillWithTitle:title value:value color:color detailedModels:[self detailedModelsForIndex:(NSUInteger) indexPath.row] separatorColor:[UIColor blackColor]];
        } else {
            if (indexPath.row == self.selectedRowIndex - 1 && indexPath.row != 0) {
                [cell fillWithTitle:title value:value color:color separatorColor:[UIColor blackColor]];
            } else {
                [cell fillWithTitle:title value:value color:color separatorColor:nil];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.selectedRowIndex = (NSUInteger) (self.selectedRowIndex == indexPath.row ? NSNotFound : (NSUInteger) indexPath.row);
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:(NSUInteger) indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

@end