//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UITableView;
@class UITableViewCell;
@class YMValueTypeStringFormat;

@protocol YMDiagramDataSource <NSObject>

@property(nonatomic) NSUInteger selectedTypeIndex;

- (NSArray *)typeTitles;

- (YMValueTypeStringFormat *)totalValueForSelectedIndex;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section isLandscape:(BOOL)isLandscape;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isLandscape:(BOOL)isLandscape;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isLandscape:(BOOL)isLandscape;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end