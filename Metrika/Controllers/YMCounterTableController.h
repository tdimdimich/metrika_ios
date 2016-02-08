//
// File: YMCounterTableController.h
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YMCounterMenuCell.h"

@class YMCounterInfo;

@protocol YMCounterTableControllerProtocol
@optional
- (void)didSelectCounter;
@end

typedef enum {
    YMCounterTableCellTypeSimple,
    YMCounterTableCellTypeWithDatePicker
} YMCounterTableCellType;

@interface YMCounterTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, YMCounterMenuCellProtocol>
@property (nonatomic) YMCounterTableCellType cellType;
@property(nonatomic, strong) NSArray *accounts;
@property (nonatomic, weak) NSObject<YMCounterTableControllerProtocol> *delegate;

// calculates table view content height, according to known counters list and constant cells height
- (CGFloat)contentHeight;

- (void)settingsWillCommitUpdates;
@end