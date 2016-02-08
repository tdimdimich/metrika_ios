//
// Created by Dmitry Korotchenkov on 21.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMAccountsSettingsController.h"
#import "YMCheckCell.h"
#import "YMAppSettings.h"
#import "YMAccountInfo.h"
#import "UIViewController+YMBackButtonAddition.h"

static const int kCellHeight = 42;
static const int kBottomBarHeight = 55;

@interface YMAccountsSettingsController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIImageView *bottomBarShadow;
@property(nonatomic, strong) IBOutlet UIButton *okButton;
@property(nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@property(nonatomic, strong) NSArray *accounts;
@end

@implementation YMAccountsSettingsController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.accounts = [YMAppSettings getAccounts];

        self.selectedIndexes = [NSMutableIndexSet new];
        for (NSUInteger i = 0; i < self.accounts.count; i++) {
            YMAccountInfo *account = self.accounts[i];
            if (!account.hidden)
                [self.selectedIndexes addIndex:i];
        }
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bottomBarShadow.hidden = self.accounts.count * kCellHeight < self.tableView.height - kBottomBarHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

#pragma mark user interactions

- (IBAction)editTap {
    UIViewController *editAccountsController = [self.storyboard instantiateViewControllerWithIdentifier:@"editAccountsControllerID"];
    [self.navigationController pushViewController:editAccountsController animated:YES];
}

- (IBAction)confirmOk {
    for (NSUInteger i = 0; i < self.accounts.count; i++) {
        YMAccountInfo *account = self.accounts[i];
        account.hidden = ![self.selectedIndexes containsIndex:i];
    }
    [YMAppSettings commitUpdates];
    [self back];
}

#pragma mark UITableView delegate, dataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAccountInfo *accountInfo = [self.accounts objectAtIndex:(NSUInteger) indexPath.row];
    YMCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkAccountCellID"];
    [cell fillWithTitle:accountInfo.name checked:[self.selectedIndexes containsIndex:(NSUInteger) indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexes containsIndex:(NSUInteger) indexPath.row]) {
        [self.selectedIndexes removeIndex:(NSUInteger) indexPath.row];

    } else {
        [self.selectedIndexes addIndex:(NSUInteger) indexPath.row];
    }
    self.okButton.enabled = self.selectedIndexes.count != 0;
    [self.tableView reloadData];
}

@end