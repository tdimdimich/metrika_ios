//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YMUtils.h"

@class YMPointPlotData;
@class YMColsPlotData;

@protocol YMGraphDataSource <NSObject>

@property(nonatomic) NSUInteger selectedTypeIndex;
@property(nonatomic) YMInterval selectedInterval;

- (YMColsPlotData *)colsPlotData;
- (YMPointPlotData *)pointPlotData;
-(NSArray *)typeTitles;
- (void)didSelectInterval:(YMInterval)interval;
- (NSArray *)titlesForXValue:(CGFloat)x;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end