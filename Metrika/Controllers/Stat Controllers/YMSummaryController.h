//
// File: YMSummaryController.h
// Project: Metrika
//
// Created by dkorneev on 9/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DKPullToRefresh;


@interface YMSummaryController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) IBOutlet UIView *contentView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

+ (YMSummaryController *)loadController;
@end