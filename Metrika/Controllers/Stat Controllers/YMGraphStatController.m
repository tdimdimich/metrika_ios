//
// Created by Dmitry Korotchenkov on 29/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMGraphStatController.h"
#import "YMGraphDataSource.h"
#import "YMPointPlotView.h"
#import "YMPointPlotData.h"
#import "YMColsPlotData.h"
#import "YMAppSettings.h"
#import "YMColsPlotView.h"
#import "YMTableCellForPlots.h"
#import "YMCheckButton.h"
#import "YMAppDelegate.h"
#import "YMGradientColor.h"
#import "YMErrorAndLoadingCellsFactory.h"

static const int kPlotViewHeight = 110;

@implementation YMGraphStatController


- (void)setListDataAndActionForCell:(YMTableCellForPlots *)cell {
    [cell setListData:self.dataSource.typeTitles selectedIndex:0 target:self action:@selector(didSelectGraphData:)];
}

- (void)didSelectGraphData:(NSNumber *)index {
    self.dataSource.selectedTypeIndex = index.unsignedIntValue;
    [self redrawPlot];
    if ([self.tableView numberOfSections] > 1) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)redrawPlot {
    UIView *plotSuperView = nil;
    CGRect frame;
    if (self.plotView) {
        frame = self.plotView.frame;
        plotSuperView = [self.plotView superview];
        [self.plotView removeFromSuperview];
    } else {
        frame = CGRectMake(0, 0, self.tableView.width, kPlotViewHeight);
    }
    if (self.graphTypeIsPoints) {
        self.plotView = [[YMPointPlotView alloc] initWithFrame:frame plotData:[self.dataSource pointPlotData] color:[YMAppSettings selectedCounter].color delegate:self];
    } else {
        self.plotView = [[YMColsPlotView alloc] initWithFrame:frame plotData:[self.dataSource colsPlotData] color:[YMAppSettings selectedCounter].color delegate:self];
    }
    [self.plotView setSelectedInterval:self.dataSource.selectedInterval];
    self.plotView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (plotSuperView) {
        [plotSuperView addSubview:self.plotView];
    }
}

- (void)didChangeGraphType:(YMCheckButton *)checkButton {
    self.graphTypeIsPoints = !checkButton.selected;
    [self redrawPlot];
}

- (void)updateDataSourceForCounter:(YMCounter *)counter success:(void (^)())success error:(void (^)(NSError *))failure {
    [self getDataSourceForCounter:counter
                          success:^(NSObject <YMGraphDataSource> *dataSource) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  self.dataSource = dataSource;
                                  [self redrawPlot];
                                  success();
                                  [self setListDataAndActionForCell:(YMTableCellForPlots *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
                              });
                          }
                            error:^(NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.dataSource = nil;
                                    failure(error);
                                });
                            }];
}

// must be overridden
- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMGraphDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark UTableView delegate and dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.dataSource ||
            self.controllerMode != YMStatControllerModeNormal ||
            self.isLandscapeMode)
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if (section == 0) {
            return 1;
        }
        else
            return self.dataSource ? [self.dataSource tableView:tableView numberOfRowsInSection:0] : 0;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if (indexPath.section == 0) {
            return self.isLandscapeMode ? [APPDELEGATE window].width : kPlotViewHeight + kTableCellForPlotBottomBarHeight;
        }
        else
            return self.dataSource ? [self.dataSource tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
    }
    return self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if (indexPath.section == 0) {
            YMTableCellForPlots *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellForPlotsID];
            if (!cell) {
                cell = [YMTableCellForPlots createCell];
                [cell setChangeTypeTarget:self action:@selector(didChangeGraphType:)];
                [self setListDataAndActionForCell:cell];
                [cell addSubview:self.plotView];
            }
            [cell setColor:[YMAppSettings selectedCounter].color.startColor];
            return cell;
        } else {
            return [self.dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        }
    } else if (self.controllerMode == YMStatControllerModeError) {
        UITableViewCell *cell;
        if (self.errorText && self.errorText.length > 0) {
            cell = [YMErrorAndLoadingCellsFactory errorPeriodCellWithText:self.errorText];
        } else {
            cell = [YMErrorAndLoadingCellsFactory errorConnectionCell];
        }
        return cell;
    } else {
        return [YMErrorAndLoadingCellsFactory loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if (indexPath.section == 1) {
            [self.dataSource tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark YMPlotView delegate methods

- (void)didSelectInterval:(YMInterval)interval {
    [self.dataSource didSelectInterval:interval];
    if ([self.tableView numberOfSections] > 1) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (NSArray *)plotView:(YMPlotView *)plotView titlesForXValue:(CGFloat)x {
    return [self.dataSource titlesForXValue:x];
}

@end