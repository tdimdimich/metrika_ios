//
// File: YMCounterTableController.m
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMCounterTableController.h"
#import "YMCounterInfo.h"
#import "YMAccountInfo.h"
#import "YMCounterListHeaderCell.h"
#import "YMDatePickerController.h"
#import "UIViewController+YMBackButtonAddition.h"
#import "YMGradientColor.h"
#import "YMUtils.h"
#import "YMAppSettings.h"

#define CALL_SELF_DELEGATE_OPTIONAL_METHOD(method) \
if (self.delegate && [self.delegate respondsToSelector:@selector(method)]) { \
    [self.delegate method]; \
}

@interface YMCounterTableController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet YMCounterListCell *reuseCell;
@property(nonatomic, strong) NSArray *counters;
@property(nonatomic, strong) YMCounterInfo *updatedDateCounter;
@property(nonatomic, strong) NSDate *updatedDateEnd;
@property(nonatomic, strong) NSDate *updatedDateStart;
@end

@implementation YMCounterTableController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.cellType = YMCounterTableCellTypeSimple;
        self.accounts = [NSArray new];
        self.counters = [NSArray new];
    }
    return self;
}

- (void)setAccounts:(NSArray *)accounts {
    _accounts = accounts;

    // restructure counters NSSet to NSArray
    NSMutableArray *counters = [NSMutableArray new];
    for (YMAccountInfo *account in _accounts) {
        [counters addObject:account.visibleCountersInfo];
    }
    self.counters = counters;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    if (!SYSTEM_VERSION_LESS_THAN_7) {
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
        blackView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackView];
    }
    self.reuseCell.backgroundColor = [UIColor clearColor];
    self.reuseCell.contentView.backgroundColor = [UIColor clearColor];
}

- (CGFloat)contentHeight {
    CGFloat totalHeight = 0;
    for (NSArray *settingsArray in self.counters) {
//        totalHeight += [YMCounterListHeaderCell cellHeight];
        totalHeight += settingsArray.count * [self cellHeight];
    }
    return totalHeight;
}

- (CGFloat)cellHeight {
    if (self.cellType == YMCounterTableCellTypeSimple)
        return [YMCounterListCell cellHeight];

    else return [YMCounterMenuCell cellHeight];
}

- (void)viewDidLayoutSubviews {
    self.tableView.scrollEnabled = self.tableView.height < self.contentHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.frame = self.view.superview.bounds;
}

- (YMCounterInfo *)getCounterInfo:(NSIndexPath *)indexPath {
    NSArray *settingsArray = self.counters[(NSUInteger) indexPath.section];
    YMCounterInfo *counterInfo = settingsArray[(NSUInteger) indexPath.row];
    return counterInfo;
}

#pragma mark YMCounterMenuCellProtocol

- (void)calendarButtonTap:(NSIndexPath *)indexPath {
    YMDatePickerController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"datePickerControllerId"];
    YMCounterInfo *counter = [self getCounterInfo:indexPath];
    controller.counter = counter;

    controller.confirmBlock = ^(NSDate *dateStart, NSDate *dateEnd){
        self.updatedDateCounter = counter;
        self.updatedDateStart = dateStart;
        self.updatedDateEnd = dateEnd;
        [self back];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)settingsWillCommitUpdates {
    YMCounterInfo *selectedCounter = [YMAppSettings selectedCounter];
    if (self.updatedDateCounter && [self.updatedDateCounter isEqual:selectedCounter]) {
        selectedCounter.dateStart = self.updatedDateStart;
        selectedCounter.dateEnd = self.updatedDateEnd;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSUInteger i = 0; i < self.counters.count; i++) {
        NSArray *settingsArray = self.counters[i];
        for (NSUInteger j = 0; j < settingsArray.count; j++) {
            YMCounterInfo *settings = settingsArray[j];
            settings.selected = (j == indexPath.row && i == indexPath.section);
        }
    }
    [tableView reloadData];

    CALL_SELF_DELEGATE_OPTIONAL_METHOD(didSelectCounter);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeight];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMCounterInfo *counterInfo = [self getCounterInfo:indexPath];
    if (self.cellType == YMCounterTableCellTypeSimple) {
        BOOL isLastCell = indexPath.row == ([self tableView:tableView numberOfRowsInSection:indexPath.section] - 1);
        YMCounterListCellBorderStyle borderStyle = isLastCell ? YMCounterListCellBorderStyleNone : YMCounterListCellBorderStyleBottom;
        YMCounterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMCounterListCellReuseId"];
        [cell setTitle:counterInfo.siteName color:counterInfo.color.startColor selected:counterInfo.selected borderStyle:borderStyle];
        return cell;

    } else { // cell type == YMCounterTableCellTypeWithDatePicker
        BOOL isFirstCell = (indexPath.row == 0);
        YMCounterMenuCellBorderStyle borderStyle = isFirstCell ? YMCounterMenuCellBorderStyleNone : YMCounterMenuCellBorderStyleTop;
        YMCounterMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMCounterMenuCell"];
        [cell setSettings:counterInfo indexPath:indexPath borderStyle:borderStyle];
        cell.delegate = self;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMAccountInfo *account = (YMAccountInfo *) self.accounts[(NSUInteger) section];
    return account.visibleCountersInfo.count;
}
@end