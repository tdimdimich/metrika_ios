//
// File: YMMenuController.m
// Project: Metrika
//
// Created by dkorneev on 9/19/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <BlocksKit/NSObject+BKBlockExecution.h>
#import "YMMenuController.h"
#import "YMMenuCell.h"
#import "YMMenuModel.h"
#import "YMRootController.h"
#import "YMMenuUserCell.h"
#import "YMAppSettings.h"
#import "YMUtils.h"
#import "YMAccountInfo.h"
#import "YMSummaryController.h"
#import "YMSourcesSummaryController.h"
#import "YMEditAccountNavigationController.h"
#import "YMSourcesSearchEnginesController.h"
#import "YMGeoController.h"
#import "YMDemographyStructureController.h"
#import "YMTechBrowsersController.h"
#import "YMTechOSController.h"
#import "YMTrafficSummaryController.h"
#import "YMContentPopularController.h"
#import "YMSourcesSitesController.h"
#import "YMSourcesPhrasesController.h"
#import "YMTrafficDeepnessDepthController.h"
#import "YMTrafficDeepnessTimeController.h"
#import "YMTrafficHourlyController.h"
#import "YMTipsManager.h"
#import "YMTechGroupDisplaysController.h"
#import "YMTechDisplaysController.h"
#import "YMTechMobileController.h"
#import "YMTechMobileGroupController.h"
#import "YMTechFlashController.h"
#import "YMTechSilverlightController.h"
#import "YMTechJavaScriptController.h"
#import "YMTechCookiesController.h"
#import "YMTechJavaController.h"
#import "YMContentExitController.h"
#import "YMContentEntranceController.h"
#import "YMContentUrlController.h"
#import "YMContentTitlesController.h"
#import "YMAboutController.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAI.h"
#import "YMVKActivityItem.h"
#import "YMMessageActivity.h"
#import "YMSharingController.h"

@interface YMMenuController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *menuItems;
@property(nonatomic, strong) NSArray *displayableItems;
@property(nonatomic, strong) YMRootController *rootController;
@property(nonatomic, strong) NSArray *accounts;
@property(nonatomic, strong) YMMenuModel *lastOpenedModel;
@property(nonatomic, strong) YMMenuModel *settingsModel;
@property(nonatomic, strong) YMMenuModel *trafficSummaryModel;
@property(nonatomic, strong) YMMenuModel *sourcesSummaryModel;
@property(nonatomic, strong) YMMenuModel *geoModel;
@property(nonatomic, strong) YMMenuModel *demographyModel;
@property(nonatomic, strong) YMMenuModel *osModel;
@property(nonatomic, strong) YMMenuModel *browsersModels;
@property(nonatomic, strong) YMSharingController *sharingController;
@property(nonatomic, strong) UIView *shadowView;
@end

@implementation YMMenuController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.accounts = [YMAppSettings getAccounts];

        // any class of controllers must have method "loadController"
        self.settingsModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Settings", @"Настройки") controllerClass:[YMEditAccountNavigationController class] level:YMMenuModelLevelFirst];
        self.trafficSummaryModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Visits", @"Посещаемость") controllerClass:[YMTrafficSummaryController class] level:YMMenuModelLevelFirst];
        self.sourcesSummaryModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Summaru", @"Сводка") controllerClass:[YMSourcesSummaryController class] level:YMMenuModelLevelSecond];
        self.geoModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Countries", @"По странам мира") controllerClass:[YMGeoController class] level:YMMenuModelLevelSecond];
        self.demographyModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Sex", @"Половозрастная структура") controllerClass:[YMDemographyStructureController class] level:YMMenuModelLevelSecond];
        self.osModel = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Opeartion systems", @"Операционные системы") controllerClass:[YMTechOSController class] level:YMMenuModelLevelSecond];
        self.browsersModels = [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Brausers", @"Браузеры") controllerClass:[YMTechBrowsersController class] level:YMMenuModelLevelSecond];
        self.menuItems = @[
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Common summary", @"Общая сводка") controllerClass:[YMSummaryController class] level:YMMenuModelLevelFirst],
                self.trafficSummaryModel,
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Sources", @"Источники") controllerClass:nil level:YMMenuModelLevelFirst andSubrecords:@[
                        self.sourcesSummaryModel,
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Sites", @"Сайты") controllerClass:[YMSourcesSitesController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Search systems", @"Поисковые системы") controllerClass:[YMSourcesSearchEnginesController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Search phrases", @"Поисковые фразы") controllerClass:[YMSourcesPhrasesController class] level:YMMenuModelLevelSecond],
                ]],
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Visitors", @"Посетители") controllerClass:nil level:YMMenuModelLevelFirst andSubrecords:@[
                        self.geoModel,
                        self.demographyModel,
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Deep", @"По глубине просмотра") controllerClass:[YMTrafficDeepnessDepthController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Time", @"По времени") controllerClass:[YMTrafficDeepnessTimeController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Time of day", @"По времени суток") controllerClass:[YMTrafficHourlyController class] level:YMMenuModelLevelSecond],
                ]],
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Content", @"Содержание") controllerClass:nil level:YMMenuModelLevelFirst andSubrecords:@[
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Popular", @"Популярное") controllerClass:[YMContentPopularController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Entry pages", @"Страницы входа") controllerClass:[YMContentEntranceController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Exit pages", @"Страницы выхода") controllerClass:[YMContentExitController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Page titles", @"Заголовки страниц") controllerClass:[YMContentTitlesController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-URL params", @"Параметры URL") controllerClass:[YMContentUrlController class] level:YMMenuModelLevelSecond],
                ]],
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Technologies", @"Технологии") controllerClass:nil level:YMMenuModelLevelFirst andSubrecords:@[
                        self.browsersModels,
                        self.osModel,
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Display groupes", @"Группы дисплеев") controllerClass:[YMTechGroupDisplaysController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Display resolution", @"Разрешения дисплеев") controllerClass:[YMTechDisplaysController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Device type", @"Типы устройств") controllerClass:[YMTechMobileGroupController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Mobile devices", @"Мобильные устройства") controllerClass:[YMTechMobileController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Flash versions", @"Версии Flash") controllerClass:[YMTechFlashController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Silverlight versions", @"Версии Silverlight") controllerClass:[YMTechSilverlightController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Java availability", @"Наличие Java") controllerClass:[YMTechJavaController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Cookies availability", @"Наличие Cookies") controllerClass:[YMTechCookiesController class] level:YMMenuModelLevelSecond],
                        [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-JavaScript availability", @"Наличие JavaScript") controllerClass:[YMTechJavaScriptController class] level:YMMenuModelLevelSecond],
                ]],
                self.settingsModel,
                [YMMenuModel newModelWithName:NSLocalizedString(@"Menu-Creators", @"Создатели") controllerClass:[YMAboutController class] level:YMMenuModelLevelFirst]
        ];
        [self updateDisplayableItemsArray];
    }
    return self;
}

// (!) this function is intended only for two-level hierarchy, for other cases it must be expanded
- (void)updateDisplayableItemsArray {
    NSMutableArray *items = [NSMutableArray new];
    for (YMMenuModel *item in self.menuItems) {
        [items addObject:item];
        if (item.canBeOpened && item.opened) {
            for (YMMenuModel *subItem in item.subRecords) {
                [items addObject:subItem];
            }
        }
    }
    self.displayableItems = items;
}

// (!) this function is intended only for two-level hierarchy, for other cases it must be expanded
- (void)unSelectAll {
    void (^block)(YMMenuModel *, NSUInteger, BOOL *) = ^(YMMenuModel *item, NSUInteger idx, BOOL *stop1) {
        if (item.canBeOpened) {
            [item.subRecords enumerateObjectsUsingBlock:^(YMMenuModel *subItem, NSUInteger subIdx, BOOL *stop2) {
                subItem.selected = NO;
            }];
        }
        item.selected = NO;
    };
    [self.menuItems enumerateObjectsUsingBlock:block];
}

- (void)showSwipeTip {
    if (![YMTipsManager isMenuSwipeTipWasShown]) {
        [YMTipsManager setMenuSwipeTipWasShown];

        [self bk_performBlock:^(id obj) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [self.rootController showFilterMenu];
            [self bk_performBlock:^(id obj1) {
                [self.rootController hideFilterMenu];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }          afterDelay:0.5];
        }          afterDelay:1];
    }
}

- (void)viewDidLoad {
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-bg-pattern.png"]];
    self.rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootControllerId"];
    [self addChildViewController:self.rootController];
    self.rootController.view.frame = SYSTEM_VERSION_LESS_THAN_7 ? self.view.bounds : CGRectMake(0, 20, self.view.width, self.view.height - 20);
    [self.view addSubview:self.rootController.view];
    [self.view bringSubviewToFront:self.rootController.view];

    YMMenuModel *itemInfo = self.menuItems[0];
    [self openControllerForModel:itemInfo];

    [self showSwipeTip];
    [YMTipsManager showTipForScreenWithMenuAfterDelayIfNeeded];

    if (!SYSTEM_VERSION_LESS_THAN_7) {
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:blackView belowSubview:self.rootController.view];
    }
}

- (UIViewController *)openedController {
    return [self.rootController activeController];
}

- (BOOL)isMenuOpened {
    return [self.rootController isMenuShown];
}

- (void)openTrafficSummaryController {
    [self openControllerForModel:self.trafficSummaryModel];
}

- (void)openSourcesSummaryController {
    [self openControllerForModel:self.sourcesSummaryModel];
}

- (void)openGeoController {
    [self openControllerForModel:self.geoModel];
}

- (void)openDemographyController {
    [self openControllerForModel:self.demographyModel];
}

- (void)openOSController {
    [self openControllerForModel:self.osModel];
}

- (void)openBrowsersController {
    [self openControllerForModel:self.browsersModels];
}

- (void)openLastController {
    if (self.lastOpenedModel) {
        [self openControllerForModel:self.lastOpenedModel];
    }
}

- (void)openControllerForModel:(YMMenuModel *)model {
    if (![model isEqual:self.settingsModel]) {
        self.lastOpenedModel = model;
    }
    [self unSelectAll];
    if (model.superRecord && model.superRecord.canBeOpened) {
        model.superRecord.opened = YES;
        [self updateDisplayableItemsArray];
    }
    model.selected = YES;
    [self.tableView reloadData];
    if ([model.controllerClass respondsToSelector:@selector(loadController)]) {
        [self.rootController showController:[model.controllerClass loadController]];
        if ([model.controllerClass isSubclassOfClass:[YMStatAbstractController class]]) {
            [YMTipsManager showTipForRotatingScreenAfterDelayIfNeeded];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.rootController.view.width = self.view.width;
    if ((SYSTEM_VERSION_LESS_THAN_7 || [[UIApplication sharedApplication] isStatusBarHidden])) {
        self.rootController.view.height = self.view.height;
        self.rootController.view.top = 0;
    } else {
        self.rootController.view.height = self.view.height - 20;
        self.rootController.view.top = 20;
    }
//    self.rootController.view.height = (SYSTEM_VERSION_LESS_THAN_7 || [[UIApplication sharedApplication] isStatusBarHidden]) ? self.view.height : self.view.height - 20;
}

#pragma mark YMSharingControllerDelegate

- (void)hideSharingView {
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.sharingController.view.top = self.rootController.view.bottom - 20;

    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self.sharingController.view removeFromSuperview];
    }];
}

#pragma mark Responder Chain calls

- (void)settingsButtonTap {
    [self unSelectAll];
    [self openControllerForModel:self.settingsModel];
}

- (void)shareTap {
    [self openLastController];
    self.sharingController = [self.storyboard instantiateViewControllerWithIdentifier:@"SharingController"];
    self.sharingController.delegate = self;
    self.sharingController.view.top = self.rootController.view.bottom - 20;

    self.shadowView = [[UIView alloc] initWithFrame:self.rootController.view.bounds];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

    [self.rootController.view addSubview:self.shadowView];
    [self.rootController.view addSubview:self.sharingController.view];

    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.sharingController.view.bottom = self.rootController.view.bottom - 20;
    }];
}

- (void)exitButtonTap {
    __weak YMMenuController *weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Alert-Exit", @"Выход")
                                   message:NSLocalizedString(@"Alert-Are you sure?", @"Вы уверены?")
                         cancelButtonTitle:NSLocalizedString(@"Alert-Yes", @"Да")
                         otherButtonTitles:@[NSLocalizedString(@"Alert-No", @"Нет")]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"login/logout action"
                                                                  action:@"logout"
                                                                   label:nil
                                                                   value:nil] build]];
            [weakSelf confirmExit];
        }
    }];
}

- (void)confirmExit {
    [self.rootController hideFilterMenu];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[YMAppSettings getAccounts] bk_each:^(YMAccountInfo *obj) {
        obj.shouldBeRemoved = YES;
    }];
    [YMAppSettings removeAccounts];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 2 : self.displayableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCellReuseId"];
    if (indexPath.section == 0) {
        YMMenuModel *itemInfo = self.displayableItems[(NSUInteger) indexPath.row];
        [cell setTitle:itemInfo.name];
        cell.chosen = itemInfo.selected;
        cell.moreItemsIconHidden = !itemInfo.canBeOpened || (itemInfo.canBeOpened && itemInfo.opened);
        cell.openedCellIconHidden = !itemInfo.canBeOpened || (itemInfo.canBeOpened && !itemInfo.opened);
        [cell setCellType:(itemInfo.level == YMMenuModelLevelFirst) ? YMMenuCellTypeFirstLevel : YMMenuCellTypeSecondLevel];
        return cell;
    } else {
        if (indexPath.row == 0) {
            [cell setTitle:NSLocalizedString(@"Menu-Share", @"Поделиться")];
        } else {
            [cell setTitle:NSLocalizedString(@"Menu-Exit", @"Выход")];
        }
        cell.chosen = NO;
        cell.openedCellIconHidden = cell.moreItemsIconHidden = YES;
        [cell setCellType:YMMenuCellTypeFirstLevel];
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self shareTap];
        } else {
            [self exitButtonTap];
        }

    } else {
        YMMenuModel *itemInfo = self.displayableItems[(NSUInteger) indexPath.row];
        if (itemInfo.canBeOpened) { // open cell
            // update model
            itemInfo.opened = !itemInfo.opened;
            [self updateDisplayableItemsArray];

            // calculate needed index paths
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSIndexPath *curIndexPath = nil;
            for (NSUInteger i = 0; i < itemInfo.subRecords.count; i++) {
                curIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:indexPath.section];
                [indexPaths addObject:curIndexPath];
            }

            // update tableView
            [tableView beginUpdates];
            if (itemInfo.opened) {
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

            } else {
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            [tableView endUpdates];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        } else if (itemInfo.selected) { // cell already selected
            [self.rootController hideFilterMenu];

        } else { // select cell
            id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSString *menu = nil;
            if (itemInfo.superRecord) {
                menu = [NSString stringWithFormat:@"menu[%@-%@]", itemInfo.superRecord.name, itemInfo.name];
            } else {
                menu = [NSString stringWithFormat:@"menu[%@]", itemInfo.name];
            }
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"menu action"
                                                                  action:menu
                                                                   label:nil
                                                                   value:nil] build]];
            [self unSelectAll];
            [self openControllerForModel:itemInfo];
        }
    }
}

@end