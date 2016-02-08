//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSettingsController.h"
#import "YMAbstractSettingsCell.h"
#import "DKUtils.h"
#import "YMAccessoryButtonSettingsCell.h"
#import "YMSwitchSettingsCell.h"
#import "YMiOS7Switch.h"
#import "YMAccountsSettingsController.h"
#import "YMTableHeaderView.h"
#import "YMUtils.h"
#import "YMAppSettings.h"
#import "YMAccountInfo.h"

static NSString *const kDetailedText = @"При запросе статистики за период, уже сохраненный\n"
        "локально, данные на устройстве будут обновлены\n"
        "автоматически";

@interface YMSettingsController ()

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, copy) NSString *accountsText;
@end

@implementation YMSettingsController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSArray *accounts = [YMAppSettings getVisibleAccounts];
    if (accounts.count > 0) {
        self.accountsText = (accounts.count > 1) ? @"Несколько учетных записей" : ((YMAccountInfo *) accounts[0]).name;
    } else {
        self.accountsText = @"Не выбраны учетные записи";
    }
    [self.tableView reloadData];
}

- (void)changeAccount {
    NSLog(@"change account");
    YMAccountsSettingsController *accountsSettingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"accounsSettingsControllerID"];
    [self.navigationController pushViewController:accountsSettingsController animated:YES];
}

- (void)saveDataChanged {
    NSLog(@"save data changed");
}

- (void)saveSessionChanged:(YMiOS7Switch *)switchView {
    NSLog(@"save session : %@", switchView.selected ? @"YES" : @"NO");
}

#pragma mark UITableView delegate, dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YMAccessoryButtonSettingsCell *accessoryButtonSettingsCell = [tableView dequeueReusableCellWithIdentifier:@"accessoryButtonCellID"];
            [accessoryButtonSettingsCell fillWithMainText:self.accountsText detailedText:nil accessoryButtonTitle:@"Сменить"];
            [accessoryButtonSettingsCell addAccessoryTapTarget:self action:@selector(changeAccount)];
            return accessoryButtonSettingsCell;
        } else {
            YMSwitchSettingsCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCellID"];
            [switchCell fillWithMainText:@"Сохранять сессию после выхода" detailedText:nil];
            [switchCell addSwitchChangedState:self action:@selector(saveSessionChanged:)];
            return switchCell;
        }
    } else {
        if (indexPath.row == 0) {
            YMAccessoryButtonSettingsCell *accessoryButtonSettingsCell = [tableView dequeueReusableCellWithIdentifier:@"accessoryButtonCellID"];
            [accessoryButtonSettingsCell fillWithMainText:@"Период кэширования сессии" detailedText:nil accessoryButtonTitle:@"Неделя"];
            return accessoryButtonSettingsCell;
        } else {
            YMSwitchSettingsCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCellID"];
            [switchCell fillWithMainText:@"Сохранять данные локально" detailedText:kDetailedText];
            [switchCell addSwitchChangedState:self action:@selector(saveDataChanged)];
            return switchCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1)
        return [YMAbstractSettingsCell heightForDetailedText:kDetailedText];
    else
        return [YMAbstractSettingsCell heightForDetailedText:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return [YMTableHeaderView createSectionHeaderWithTitle:@"Учетные записи" forWidth:self.tableView.width];
    else
        return [YMTableHeaderView createSectionHeaderWithTitle:@"Кэширование" forWidth:self.tableView.width];
}

@end