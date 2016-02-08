//
// Created by Dmitry Korotchenkov on 25.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMEditAccountsController.h"
#import "YMAbstractCell.h"
#import "YMAppSettings.h"
#import "YMAccountInfo.h"
#import "YMEditAccountController.h"

@interface YMEditAccountsController ()
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation YMEditAccountsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(IBAction)deleteTap {
    UIViewController *deleteAccountsController = [self.storyboard instantiateViewControllerWithIdentifier:@"accounsDeleteControllerID"];
    [self.navigationController pushViewController:deleteAccountsController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YMAppSettings getAccounts].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAccountInfo *accountInfo = [[YMAppSettings getAccounts] objectAtIndex:(NSUInteger)indexPath.row];
    YMAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkAccountCellID"];
    [cell fillWithTitle:accountInfo.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAccountInfo *accountInfo = [[YMAppSettings getAccounts] objectAtIndex:(NSUInteger)indexPath.row];
    YMEditAccountController *editAccountController = [self.storyboard instantiateViewControllerWithIdentifier:@"editAccountControllerID"];
    [editAccountController setAccountInfo:accountInfo];
    [self.navigationController pushViewController:editAccountController animated:YES];
}

@end