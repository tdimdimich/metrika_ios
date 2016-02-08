//
// Created by Dmitry Korotchenkov on 01.10.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMAccountsDeleteController.h"
#import "YMAppSettings.h"
#import "YMAccountInfo.h"
#import "YMCheckDeleteCell.h"
#import "UIViewController+YMBackButtonAddition.h"

static const int kCellHeight = 42;
static const int kBottomBarHeight = 55;

@interface YMAccountsDeleteController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIImageView *bottomBarShadow;
@property(nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@property(nonatomic, strong) NSArray *accounts;
@end

@implementation YMAccountsDeleteController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedIndexes = [NSMutableIndexSet new];
    self.accounts = [YMAppSettings getAccounts];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bottomBarShadow.hidden = self.accounts.count * kCellHeight < self.tableView.height - kBottomBarHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)confirmDeleting {
    BOOL hasOneOrMoreAccounts = NO;
    for (NSUInteger i = 0; i < self.accounts.count; i++) {
        YMAccountInfo *account = self.accounts[i];
        if ([self.selectedIndexes containsIndex:i]) {
            account.shouldBeRemoved = YES;
        } else {
            hasOneOrMoreAccounts = YES;
        }
    }
    [YMAppSettings removeAccounts];
    if (hasOneOrMoreAccounts) {
        [self back];
    } else {
        NSUInteger settingsControllerIndex = self.navigationController.viewControllers.count - 4;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:settingsControllerIndex] animated:YES];
    }
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
    YMCheckDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkDeleteCellID"];
    [cell fillWithTitle:accountInfo.name checked:[self.selectedIndexes containsIndex:(NSUInteger) indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexes containsIndex:(NSUInteger) indexPath.row]) {
        [self.selectedIndexes removeIndex:(NSUInteger) indexPath.row];
    } else {
        [self.selectedIndexes addIndex:(NSUInteger) indexPath.row];
    }
    [self.tableView reloadData];
}
@end