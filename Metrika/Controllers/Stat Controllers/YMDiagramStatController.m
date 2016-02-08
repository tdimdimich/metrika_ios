//
// Created by Dmitry Korotchenkov on 29/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDiagramStatController.h"
#import "YMDiagramDataSource.h"
#import "YMAppDelegate.h"
#import "YMDiagramLandscapeView.h"
#import "YMListControl.h"
#import "YMAppSettings.h"
#import "YMGradientColor.h"
#import "YMValueTypeStringFormat.h"
#import "YMErrorAndLoadingCellsFactory.h"
#import "NSObject+BKBlockExecution.h"


@interface YMDiagramStatController ()
@property(nonatomic) BOOL landscapeTableAnimationShowed;
@property(nonatomic, strong) YMDiagramLandscapeView *diagramLandscapeView;
@end

@implementation YMDiagramStatController

- (void)updateDataSourceForCounter:(YMCounter *)counter success:(void (^)())success error:(void (^)(NSError *))failure {
    [self getDataSourceForCounter:counter
                          success:^(NSObject <YMDiagramDataSource> *dataSource) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  self.dataSource = dataSource;
                                  success();
                                  if (self.diagramLandscapeView) {
                                      [self updateDiagramLandscapeView];
                                  }
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
- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        self.dataSource.selectedTypeIndex = 0;
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (self.isLandscapeMode && self.diagramLandscapeView && !self.landscapeTableAnimationShowed) {
        //animation "scroll from bottom"
        NSInteger numberRowsInFirstSection = [self.diagramLandscapeView.tableView numberOfRowsInSection:0];
        if (numberRowsInFirstSection > 0) {
            NSInteger lastSection = [self.diagramLandscapeView.tableView numberOfSections] - 1;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.diagramLandscapeView.tableView numberOfRowsInSection:lastSection] - 1 inSection:lastSection];
            [self.diagramLandscapeView.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [self bk_performBlock:^(id sender) {
                [self.diagramLandscapeView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            }       afterDelay:0.3];
            self.landscapeTableAnimationShowed = YES;
        }
    }
}


- (void)didChangeDataType:(NSNumber *)index {
    self.dataSource.selectedTypeIndex = index.unsignedIntValue;
    if (self.diagramLandscapeView) {
        [self.diagramLandscapeView.tableView reloadData];
        [self updateDiagramLandscapeTotalValue];
    }
}

- (void)updateDiagramLandscapeView {
    [self.diagramLandscapeView.listControl setData:self.dataSource.typeTitles selectedIndex:0 target:self action:@selector(didChangeDataType:)];
    [self.diagramLandscapeView.listControl setColor:[YMAppSettings selectedCounter].color.startColor];
    [self.diagramLandscapeView.tableView reloadData];
    [self updateDiagramLandscapeTotalValue];
}


- (void)updateDiagramLandscapeTotalValue {
    YMValueTypeStringFormat *format = [self.dataSource totalValueForSelectedIndex];
    if (format) {
        [self.diagramLandscapeView setTotalValue:format.value totalType:format.type];
    } else {
        [self.diagramLandscapeView hideTotalValue];
    }
}

#pragma mark YMDiagramDataSource methods

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
        if ([tableView isEqual:self.tableView] && self.isLandscapeMode) {
            return 1;
        } else {
            return [self.dataSource tableView:tableView numberOfRowsInSection:section isLandscape:self.isLandscapeMode];
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if ([tableView isEqual:self.tableView] && self.isLandscapeMode) {
            return APPDELEGATE.window.width;
        } else {
            return [self.dataSource tableView:tableView heightForRowAtIndexPath:indexPath isLandscape:self.isLandscapeMode];
        }
    }
    return self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && self.controllerMode == YMStatControllerModeNormal) {
        if ([tableView isEqual:self.tableView] && self.isLandscapeMode) {
            static NSString *cellID = @"diagramLandscapeCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                YMDiagramLandscapeView *view = [YMDiagramLandscapeView createView];
                UITableView *landscapeTableView = view.tableView;
                landscapeTableView.dataSource = self;
                landscapeTableView.delegate = self;
                view.frame = cell.bounds;
                [cell addSubview:view];
                self.diagramLandscapeView = view;
                [self updateDiagramLandscapeView];
            } else {
                [self.diagramLandscapeView.tableView reloadData];
            }
            return cell;
        } else {
            return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath isLandscape:self.isLandscapeMode];
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
        if ([tableView isEqual:self.tableView]) {
            [self.dataSource tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

@end