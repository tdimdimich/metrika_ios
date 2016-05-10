//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import <DKHelper/DKUtils.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "YMEditAccountController.h"
#import "YMAccountInfo.h"
#import "YMTableHeaderView.h"
#import "YMTextFieldCell.h"
#import "YMCounterSettingsCell.h"
#import "YMCounterInfo.h"
#import "YMEditCounterController.h"
#import "YMAppSettings.h"
#import "UIViewController+YMBackButtonAddition.h"
#import "YMUtils.h"
#import "YMRootController.h"

static const int kCellHeight = 44;
static const int kBottomBarHeight = 55;

@interface YMEditAccountController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIImageView *bottomBarShadow;
@property(nonatomic, strong) IBOutlet UIButton *confirmButton;
@property(nonatomic, strong) YMAccountInfo *account;
@property(nonatomic, strong) NSArray *counters;
@property(nonatomic, strong) YMTextFieldCell *textFieldCell;
@property(nonatomic, strong) NSMutableIndexSet *visibleAccountsIndexes;
@end

@implementation YMEditAccountController

- (void)awakeFromNib {
    [super awakeFromNib];
    // пока отключин мультиаккаунтинг
    [self setAccountInfo:[[YMAppSettings getAccounts] lastObject]];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)setAccountInfo:(YMAccountInfo *)accountInfo {
    self.account = accountInfo;
    self.counters = self.account.counterInfo.allObjects;
    [self updateVisibleAccountsIndexes];
}

- (void)updateVisibleAccountsIndexes {
    self.visibleAccountsIndexes = [NSMutableIndexSet new];
    for (NSUInteger i = 0; i < self.counters.count; i++) {
        YMCounterInfo *counter = self.counters[i];
        if (!counter.hidden) {
            [self.visibleAccountsIndexes addIndex:i];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
//    self.tableView.backgroundColor = [UIColor greenColor];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!SYSTEM_VERSION_LESS_THAN_7
            && [gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]
            && gestureRecognizer.state != UIGestureRecognizerStateFailed
            && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        [otherGestureRecognizer setEnabled:NO];
        [otherGestureRecognizer setEnabled:YES];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.confirmButton.enabled = YES;
    [self updateVisibleAccountsIndexes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    }
}


- (YMCounterInfo *)counterForIndexPath:(NSIndexPath *)indexPath {
    YMCounterInfo *counterInfo = [self.counters objectAtIndex:(NSUInteger) indexPath.row];
    return counterInfo;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSUInteger contentHeight = (self.counters.count + 1) * kCellHeight + 2 * kTableSectionHeaderHeight;
    CGFloat visibleAreaHeight = self.tableView.height - kBottomBarHeight;
    self.bottomBarShadow.hidden = contentHeight < visibleAreaHeight;
}

- (IBAction)deleteAccount {
    self.account.shouldBeRemoved = YES;
    [YMAppSettings removeAccounts];
    if ([YMAppSettings getAccounts].count > 0) {
        [self back];
    } else {
        NSUInteger settingsControllerIndex = self.navigationController.viewControllers.count - 4;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:settingsControllerIndex] animated:YES];
    }
}

- (IBAction)confirmOk {
    for (NSUInteger i = 0; i < self.counters.count; i++) {
        YMCounterInfo *counter = self.counters[i];
        counter.hidden = ![self.visibleAccountsIndexes containsIndex:i];
    }

    if ([YMAppSettings selectedCounter].hidden) {
        [YMAppSettings selectedCounter].selected = NO;
        YMAccountInfo *account = [[YMAppSettings getVisibleAccounts] firstObject];
        YMCounterInfo *counter = account.visibleCountersInfo.firstObject;
        counter.selected = YES;
    }
    [YMAppSettings commitUpdates];
    [APPDELEGATE.menuController openLastController];
}

#pragma mark UITableView delegate, dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.counters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMCounterSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"counterCellID"];
    [cell fillWithCounter:[self counterForIndexPath:indexPath] delegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [YMTableHeaderView createSectionHeaderWithTitle:NSLocalizedString(@"Counters", @"Счетчики") forWidth:self.tableView.width];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
    separator.backgroundColor = [DKUtils colorWithRed:200 green:200 blue:200];
    [headerView addSubview:separator];
    return headerView;
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark YMCounterSettingsCellDelegate methods

- (void)cell:(YMCounterSettingsCell *)cell didChangeVisibleState:(BOOL)stateNew {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (stateNew) {
        [self.visibleAccountsIndexes addIndex:(NSUInteger) indexPath.row];
    } else {
        [self.visibleAccountsIndexes removeIndex:(NSUInteger) indexPath.row];
    }
    self.confirmButton.enabled = self.visibleAccountsIndexes.count > 0;

}

- (void)cellDidEditTap:(YMCounterSettingsCell *)cell {
    YMCounterInfo *counter = [self counterForIndexPath:[self.tableView indexPathForCell:cell]];
    YMEditCounterController *editCounterController = [self.storyboard instantiateViewControllerWithIdentifier:@"editCounterControllerID"];
    editCounterController.counter = counter;
    [self.navigationController pushViewController:editCounterController animated:YES];
}

@end