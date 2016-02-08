//
// File: YMSummaryController.m
// Project: Metrika
//
// Created by dkorneev on 9/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import <Objection/Objection.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "YMSummaryController.h"
#import "YMCounterMenuController.h"
#import "YMSummaryVisitorsCell.h"
#import "YMAppSettings.h"
#import "YMGradientColor.h"
#import "YMValueTypeStringFormat.h"
#import "DKPullToRefresh.h"
#import "YMSummaryTimeCell.h"
#import "NSDate+YMAdditions.h"
#import "YMTrafficSummaryService.h"
#import "YMCounter.h"
#import "YMTrafficSummary.h"
#import "YMSourcesSummaryService.h"
#import "YMSourcesSummaryWrapper.h"
#import "YMSourcesSummary.h"
#import "YMUtils.h"
#import "YMSummarySourcesCell.h"
#import "YMSummaryOSCell.h"
#import "YMTechOSService.h"
#import "YMTechOSWrapper.h"
#import "YMTechOS.h"
#import "YMTechBrowsersService.h"
#import "YMTechBrowsersWrapper.h"
#import "YMTechBrowsers.h"
#import "YMSummaryBrowsersCell.h"
#import "YMSummaryGenderCell.h"
#import "YMDemographyStructureService.h"
#import "YMDemographyStructure.h"
#import "YMDemographyStructureWrapper.h"
#import "YMSummaryAgeCell.h"
#import "YMGeoService.h"
#import "YMGeoWrapper.h"
#import "YMGeo.h"
#import "YMSummaryGeoCell.h"
#import "DKPullToRefresh.h"
#import "UIScrollView+DKAdditions.h"
#import "YMMenuController.h"
#import "YMPullToRefreshHeaderView.h"
#import "YMErrorAndLoadingCellsFactory.h"
#import "YMTipsManager.h"

typedef enum {
    YMSummaryCellVisitors,
    YMSummaryCellTime,
    YMSummaryCellSources,
    YMSummaryCellGeo,
    YMSummaryCellGender,
    YMSummaryCellAge,
    YMSummaryCellBrowsers,
    YMSummaryCellOS,
    YMSummaryCellCount
} YMSummaryCell;

typedef enum {
    YMSummaryControllerModeLoading,
    YMSummaryControllerModeNormal,
    YMSummaryControllerModeError,
} YMSummaryControllerMode;

@interface YMSummaryController ()
@property(nonatomic, strong) YMCounterMenuController *menuController;
@property(nonatomic, strong) YMTrafficSummaryService *trafficSummaryService;
@property(nonatomic, strong) YMSourcesSummaryService *sourcesSummaryService;
@property(nonatomic, strong) YMDemographyStructureService *demographyService;
@property(nonatomic, strong) YMGeoService *geoService;
@property(nonatomic, strong) YMTechOSService *osService;
@property(nonatomic, strong) YMTechBrowsersService *browsersService;
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) DKPullToRefresh *refresh;
@property(nonatomic) YMSummaryControllerMode controllerMode;
@end

@implementation YMSummaryController

objection_requires(@"trafficSummaryService", @"sourcesSummaryService", @"osService", @"browsersService", @"demographyService", @"geoService")

+ (YMSummaryController *)loadController {
    return [STORYBOARD instantiateViewControllerWithIdentifier:@"summaryControllerID"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)willEnterForeground {
    if ([YMTipsManager shouldShowRateView]) {
        [YMTipsManager showRateView];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[JSObjection defaultInjector] injectDependencies:self];

    self.data = [NSMutableArray arrayWithArray:@[
            [NSNull null],
            [NSNull null],
            [NSNull null],
            [NSNull null],
            [NSNull null],
            [NSNull null],
            [NSNull null],
            [NSNull null],
    ]];
    self.controllerMode = YMSummaryControllerModeLoading;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.menuController = [STORYBOARD instantiateViewControllerWithIdentifier:@"CounterMenuController"];
    [self addChildViewController:self.menuController];
    self.menuController.view.top = 0;
    self.menuController.view.left = 0;
    [self.view addSubview:self.menuController.view];
    [self.view bringSubviewToFront:self.menuController.view];
    self.view.clipsToBounds = YES;
    self.contentView.top += [self.menuController minHeight];
    self.contentView.height -= [self.menuController minHeight];
    [self.menuController minimizeAnimated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:kAppSettingsDidUpdateNotification object:nil];
    [self reloadAll];

    YMPullToRefreshHeaderView *pullToRefreshView = [YMPullToRefreshHeaderView createView];
    [pullToRefreshView setReloadTarget:self action:@selector(reloadAll)];
    self.refresh = [[DKPullToRefresh alloc] initWithScrollView:self.tableView
                                                    headerView:pullToRefreshView
                                         offsetForStartLoading:pullToRefreshView.height
                                              changeStateBlock:pullToRefreshView.changeStateHandler];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([YMTipsManager shouldShowRateView]) {
        [YMTipsManager showRateView];
    }
}

- (void)reloadAll {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    YMCounter *counter = counterInfo.counter;
    if (!counter)
        return;
    self.controllerMode = YMSummaryControllerModeLoading;
    [self updateTraffic];
    [self updateSources];
    [self updateGeo];
    [self updateDemography];
    [self updateOS];
    [self updateBrowsers];
}

- (void)updateTraffic {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellVisitors] = [NSNull null];
    weakSelf.data[YMSummaryCellTime] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.trafficSummaryService getSummaryForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(NSArray *content) {
        __block NSUInteger total = 0;
        __block NSUInteger maxVisitors = 0;
        __block NSUInteger maxTime = 0;
        __block NSDate *maxDate = nil;
        __block NSUInteger totalTime = 0;
        [content bk_each:^(YMTrafficSummary *traffic) {
            if (traffic.visitors.unsignedIntValue > maxVisitors) {
                maxVisitors = traffic.visitors.unsignedIntValue;
            }
            if (traffic.visitTime.unsignedIntValue > maxTime) {
                maxTime = traffic.visitTime.unsignedIntValue;
                maxDate = traffic.date;
            }
            totalTime += traffic.visitTime.unsignedIntValue * traffic.visitors.unsignedIntValue;
            total += traffic.visitors.unsignedIntValue;
        }];
        totalTime = (total != 0) ? totalTime / total : 0;

        weakSelf.data[YMSummaryCellVisitors] = @[
                [YMValueTypeStringFormat formatFromFloatValue:total],
                [YMValueTypeStringFormat formatFromFloatValue:maxVisitors],
        ];
        weakSelf.data[YMSummaryCellTime] = @[
                [YMValueTypeStringFormat timeFormatFromSeconds:totalTime],
                maxDate ? [YMValueTypeStringFormat timeFormatFromSeconds:maxTime] : [NSNull null],
                maxDate ?: [NSNull null]
        ];
        [self reloadTableIfNeeded];
    }                                        failure:^(NSError *error) {
        self.data[YMSummaryCellVisitors] = error;
        self.data[YMSummaryCellTime] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)updateSources {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellSources] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.sourcesSummaryService getSummaryForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(YMSourcesSummaryWrapper *content) {
        NSArray *sortedArray = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMSourcesSummary *obj1, YMSourcesSummary *obj2) {
            return floatCompare(obj2.visits.floatValue, obj1.visits.floatValue);
        }];
        NSMutableArray *result = [NSMutableArray new];
        if (sortedArray.count > 0) {
            [result addObject:@[
                    [YMValueTypeStringFormat formatFromFloatValue:[(YMSourcesSummary *) sortedArray[0] visits].floatValue],
                    [[[(YMSourcesSummary *) sortedArray[0] name] lowercaseString] stringByAppendingString:@"."]
            ]];
            if (sortedArray.count > 1) {
                [result addObject:@[
                        [YMValueTypeStringFormat formatFromFloatValue:[(YMSourcesSummary *) sortedArray[1] visits].floatValue],
                        [[[(YMSourcesSummary *) sortedArray[1] name] lowercaseString] stringByAppendingString:@"."]
                ]];
                if (sortedArray.count > 2) {
                    [result addObject:@[
                            [YMValueTypeStringFormat formatFromFloatValue:[(YMSourcesSummary *) sortedArray[2] visits].floatValue],
                            [[[(YMSourcesSummary *) sortedArray[2] name] lowercaseString] stringByAppendingString:@"."]
                    ]];
                }
            }
        }

        weakSelf.data[YMSummaryCellSources] = result;
        [self reloadTableIfNeeded];

    }                                        failure:^(NSError *error) {
        self.data[YMSummaryCellSources] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)updateGeo {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellGeo] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.geoService getGeoForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(YMGeoWrapper *content) {
        NSArray *sortedArray = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMGeo *obj1, YMGeo *obj2) {
            return floatCompare(obj2.visits.floatValue, obj1.visits.floatValue);
        }];

        NSMutableArray *result = [NSMutableArray new];
        if (sortedArray.count > 0) {
            [result addObject:@[
                    [YMValueTypeStringFormat formatFromFloatValue:[(YMGeo *) sortedArray[0] visits].floatValue],
                    [(YMGeo *) sortedArray[0] name],
            ]];
            if (sortedArray.count > 1) {
                [result addObject:@[
                        [YMValueTypeStringFormat formatFromFloatValue:[(YMGeo *) sortedArray[1] visits].floatValue],
                        [(YMGeo *) sortedArray[1] name],
                ]];
                if (sortedArray.count > 2) {
                    [result addObject:@[
                            [YMValueTypeStringFormat formatFromFloatValue:[(YMGeo *) sortedArray[2] visits].floatValue],
                            [(YMGeo *) sortedArray[2] name],
                    ]];
                }
            }
        }

        weakSelf.data[YMSummaryCellGeo] = result;
        [self reloadTableIfNeeded];

    }                         failure:^(NSError *error) {
        self.data[YMSummaryCellGeo] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)updateDemography {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellGender] = [NSNull null];
    weakSelf.data[YMSummaryCellAge] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.demographyService getDemographyForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(YMDemographyStructureWrapper *content) {
        NSArray *genderResult = @[[NSNumber numberWithFloat:content.malePercent], [NSNumber numberWithFloat:content.femalePercent]];
        NSMutableArray *groupingArray = [NSMutableArray new];
        [content.data.allObjects bk_each:^(YMDemographyStructure *demographyStructure) {
            NSMutableDictionary *dictionary = [groupingArray bk_match:^BOOL(NSDictionary *dict) {
                return [dict[@"title"] isEqualToString:demographyStructure.name];
            }];
            if (!dictionary) {
                dictionary = [NSMutableDictionary new];
                dictionary[@"title"] = demographyStructure.name;
                dictionary[@"value"] = demographyStructure.visitsPercent;
                [groupingArray addObject:dictionary];
            } else {
                dictionary[@"value"] = [NSNumber numberWithFloat:[dictionary[@"value"] floatValue] + demographyStructure.visitsPercent.floatValue];
            }
        }];
        [groupingArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            return floatCompare([obj2[@"value"] floatValue], [obj1[@"value"] floatValue]);
        }];
        NSMutableArray *ageResult = [NSMutableArray new];
        if (groupingArray.count > 0) {
            [ageResult addObject:@[
                    groupingArray[0][@"title"],
                    groupingArray[0][@"value"],
            ]];
            if (groupingArray.count > 1) {
                [ageResult addObject:@[
                        groupingArray[1][@"title"],
                        groupingArray[1][@"value"],
                ]];
                if (groupingArray.count > 2) {
                    [ageResult addObject:@[
                            groupingArray[2][@"title"],
                            groupingArray[2][@"value"],
                    ]];
                }
            }
        }
        weakSelf.data[YMSummaryCellGender] = genderResult;
        weakSelf.data[YMSummaryCellAge] = ageResult;
        [self reloadTableIfNeeded];
    }                                       failure:^(NSError *error) {
        self.data[YMSummaryCellGender] = error;
        self.data[YMSummaryCellAge] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)updateOS {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellOS] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.osService getOSForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(YMTechOSWrapper *content) {
        NSArray *sortedArray = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMTechOS *obj1, YMTechOS *obj2) {
            return floatCompare(obj2.visits.floatValue, obj1.visits.floatValue);
        }];

        __block CGFloat total = 0;
        [sortedArray bk_each:^(YMTechOS *currentBrowser) {
            total += currentBrowser.visits.floatValue;
        }];

        NSMutableArray *result = [NSMutableArray new];
        if (sortedArray.count > 0) {
            [result addObject:@[
                    [(YMTechOS *) sortedArray[0] name],
                    [NSNumber numberWithFloat:(([(YMTechOS *) sortedArray[0] visits].floatValue / total) * 100)]
            ]];
            if (sortedArray.count > 1) {
                [result addObject:@[
                        [(YMTechOS *) sortedArray[1] name],
                        [NSNumber numberWithFloat:(([(YMTechOS *) sortedArray[1] visits].floatValue / total) * 100)]
                ]];
                if (sortedArray.count > 2) {
                    [result addObject:@[
                            [(YMTechOS *) sortedArray[2] name],
                            [NSNumber numberWithFloat:(([(YMTechOS *) sortedArray[2] visits].floatValue / total) * 100)]
                    ]];
                }
            }
        }

        weakSelf.data[YMSummaryCellOS] = result;
        [self reloadTableIfNeeded];
    }                       failure:^(NSError *error) {
        self.data[YMSummaryCellOS] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)updateBrowsers {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    __weak YMSummaryController *weakSelf = self;

    weakSelf.data[YMSummaryCellBrowsers] = [NSNull null];
    [self reloadTableIfNeeded];

    [self.browsersService getBrowsersForCounter:counterInfo.counter.id token:counterInfo.counter.token fromDate:counterInfo.dateStart toDate:counterInfo.dateEnd success:^(YMTechBrowsersWrapper *content) {
        NSArray *sortedArray = [content.data.allObjects sortedArrayUsingComparator:^NSComparisonResult(YMTechBrowsers *obj1, YMTechBrowsers *obj2) {
            return floatCompare(obj2.visits.floatValue, obj1.visits.floatValue);
        }];

        __block CGFloat total = 0;
        [sortedArray bk_each:^(YMTechOS *currentBrowser) {
            total += currentBrowser.visits.floatValue;
        }];

        NSMutableArray *result = [NSMutableArray new];
        if (sortedArray.count > 0) {
            [result addObject:@[
                    [(YMTechBrowsers *) sortedArray[0] name],
                    [NSNumber numberWithFloat:(([(YMTechBrowsers *) sortedArray[0] visits].floatValue / total) * 100)]
            ]];
            if (sortedArray.count > 1) {
                [result addObject:@[
                        [(YMTechBrowsers *) sortedArray[1] name],
                        [NSNumber numberWithFloat:(([(YMTechBrowsers *) sortedArray[1] visits].floatValue / total) * 100)]
                ]];
                if (sortedArray.count > 2) {
                    [result addObject:@[
                            [(YMTechBrowsers *) sortedArray[2] name],
                            [NSNumber numberWithFloat:(([(YMTechBrowsers *) sortedArray[2] visits].floatValue / total) * 100)]
                    ]];
                }
            }
        }

        weakSelf.data[YMSummaryCellBrowsers] = result;
        [self reloadTableIfNeeded];

    }                                   failure:^(NSError *error) {
        self.data[YMSummaryCellBrowsers] = error;
        [self reloadTableIfNeeded];
    }];
}

- (void)reloadTableIfNeeded {
    BOOL matchError = [self.data bk_any:^BOOL(id obj) {
        return [obj isKindOfClass:[NSError class]];
    }];

    if (matchError) {
        self.controllerMode = YMSummaryControllerModeError;

    } else {
        BOOL notMatchNull = [self.data bk_none:^BOOL(id obj) {
            return [obj isKindOfClass:[NSNull class]];
        }];
        if (notMatchNull) {
            if (self.controllerMode != YMSummaryControllerModeNormal) {
                self.controllerMode = YMSummaryControllerModeNormal;
                [self.refresh cancelLoading];
            }
        } else {
            self.controllerMode = YMSummaryControllerModeLoading;
        }
    }
}

- (void)setControllerMode:(YMSummaryControllerMode)controllerMode {
    if (self.controllerMode != controllerMode) {
        _controllerMode = controllerMode;
        [self.tableView reloadData];
    }
}

#pragma mark UITableView dataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.controllerMode == YMSummaryControllerModeNormal)
        return YMSummaryCellCount;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.controllerMode == YMSummaryControllerModeLoading) {
        return [YMErrorAndLoadingCellsFactory loadingCell];

    } else if (self.controllerMode == YMSummaryControllerModeError) {
        NSError *error = [self.data bk_match:^BOOL(id obj) {
            return [obj isKindOfClass:[NSError class]];
        }];
        NSString *errorText = nil;
        if ([[YMAbstractEntity codesForError:error] bk_any:^BOOL(NSString *obj) {
            return [YMAbstractEntity isCodeForPeriodError:obj];
        }]) {
            errorText = [YMAbstractEntity textForError:error];
        }
        if (errorText)
            return [YMErrorAndLoadingCellsFactory errorPeriodCellWithText:errorText];
        else
            return [YMErrorAndLoadingCellsFactory errorConnectionCell];

    } else {
        UIColor *color = [YMAppSettings selectedCounter].color.startColor;
        if (indexPath.row == YMSummaryCellVisitors) {
            YMSummaryVisitorsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"visitorsCellID"];
            YMValueTypeStringFormat *total = self.data[YMSummaryCellVisitors][0];
            YMValueTypeStringFormat *max = self.data[YMSummaryCellVisitors][1];
            [cell fillWithColor:color totalValue:total dailyValue:max];
            return cell;

        } else if (indexPath.row == YMSummaryCellTime) {
            YMSummaryTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCellID"];
            YMValueTypeStringFormat *total = self.data[YMSummaryCellTime][0];
            YMValueTypeStringFormat *maxTime = self.data[YMSummaryCellTime][1];
            NSDate *maxTimeDate = self.data[YMSummaryCellTime][2];
            if (![maxTime isKindOfClass:[YMValueTypeStringFormat class]] || ![maxTimeDate isKindOfClass:[NSDate class]]) {
                maxTimeDate = nil;
                maxTime = nil;
            }
            [cell fillWithTotalValue:total maxRecordValue:maxTime maxRecordDate:maxTimeDate];
            return cell;

        } else if (indexPath.row == YMSummaryCellSources) {
            YMSummarySourcesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourcesCellID"];
            NSArray *result = self.data[YMSummaryCellSources];
            YMValueTypeStringFormat *firstFormat = nil, *secondFormat = nil, *thirdFormat = nil;
            NSString *firstString = nil, *secondString = nil, *thirdString = nil;
            if (result.count > 0) {
                firstFormat = result[0][0];
                firstString = result[0][1];
                if (result.count > 1) {
                    secondFormat = result[1][0];
                    secondString = result[1][1];
                    if (result.count > 2) {
                        thirdFormat = result[2][0];
                        thirdString = result[2][1];
                    }
                }

            } else {
                firstFormat = [YMValueTypeStringFormat formatFromFloatValue:0];
                firstString = @"";
            }
            [cell fillWithMaxValue:firstFormat
                           maxText:firstString
                       secondValue:secondFormat
                        secondText:secondString
                        trirdValue:thirdFormat
                         thirdText:thirdString];
            return cell;

        } else if (indexPath.row == YMSummaryCellGeo) {
            YMSummaryGeoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"geoCellID"];
            NSArray *result = self.data[YMSummaryCellGeo];
            YMValueTypeStringFormat *firstFormat = nil, *secondFormat = nil, *thirdFormat = nil;
            NSString *firstString = nil, *secondString = nil, *thirdString = nil;
            if (result.count > 0) {
                firstFormat = result[0][0];
                firstString = result[0][1];
                if (result.count > 1) {
                    secondFormat = result[1][0];
                    secondString = result[1][1];
                    if (result.count > 2) {
                        thirdFormat = result[2][0];
                        thirdString = result[2][1];
                    }
                }
            } else {
                firstFormat = [YMValueTypeStringFormat formatFromFloatValue:0];
                firstString = @"";
            }
            [cell fillWithFirstTitle:firstString
                          firstValue:firstFormat
                         secondTitle:secondString
                         secondValue:secondFormat
                          thirdTitle:thirdString
                          thirdValue:thirdFormat
                               color:color];
            return cell;

        } else if (indexPath.row == YMSummaryCellGender) {
            YMSummaryGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genderCellID"];
            NSArray *result = self.data[YMSummaryCellGender];
            [cell fillWithMaleValue:[result[0] floatValue] femaleValue:[result[1] floatValue] color:color];
            return cell;

        } else if (indexPath.row == YMSummaryCellAge) {
            YMSummaryAgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ageCellID"];
            NSArray *result = self.data[YMSummaryCellAge];
            NSString *firstTitle = nil, *secondTitle = nil, *thirdTitle = nil;
            CGFloat firstPercent = 0, secondPercent = 0, thirdPercent = 0;
            if (result.count > 0) {
                firstTitle = result[0][0];
                firstPercent = [result[0][1] floatValue];
                if (result.count > 1) {
                    secondTitle = result[1][0];
                    secondPercent = [result[1][1] floatValue];
                    if (result.count > 2) {
                        thirdTitle = result[2][0];
                        thirdPercent = [result[2][1] floatValue];
                    }
                }
            }
            [cell fillWithFirstTitle:firstTitle firstPercent:firstPercent secondTitle:secondTitle secondPercent:secondPercent thirdTitle:thirdTitle thirdPercent:thirdPercent color:color];
            return cell;

        } else if (indexPath.row == YMSummaryCellOS) {
            YMSummaryOSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"osCellID"];
            NSArray *result = self.data[YMSummaryCellOS];
            NSString *firstName = nil, *secondName = nil, *thirdName = nil;
            NSNumber *firstPercent = nil, *secondPercent = nil, *thirdPercent = nil;
            if (result.count > 0) {
                firstName = result[0][0];
                firstPercent = result[0][1];
                if (result.count > 1) {
                    secondName = result[1][0];
                    secondPercent = result[1][1];
                    if (result.count > 2) {
                        thirdName = result[2][0];
                        thirdPercent = result[2][1];
                    }
                }
            }
            [cell fillWithFirstName:firstName
                       firstPercent:firstPercent.floatValue
                         secondName:secondName
                      secondPercent:secondPercent.floatValue
                          thirdName:thirdName
                       thirdPercent:thirdPercent.floatValue
                              color:color];
            return cell;

        } else if (indexPath.row == YMSummaryCellBrowsers) {
            YMSummaryBrowsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"browsersCellID"];
            NSArray *result = self.data[YMSummaryCellBrowsers];
            NSString *firstName = nil, *secondName = nil, *thirdName = nil;
            NSNumber *firstPercent = nil, *secondPercent = nil, *thirdPercent = nil;
            if (result.count > 0) {
                firstName = result[0][0];
                firstPercent = result[0][1];
                if (result.count > 1) {
                    secondName = result[1][0];
                    secondPercent = result[1][1];
                    if (result.count > 2) {
                        thirdName = result[2][0];
                        thirdPercent = result[2][1];
                    }
                }
            }
            [cell fillWithFirstName:firstName
                       firstPercent:firstPercent.floatValue
                         secondName:secondName
                      secondPercent:secondPercent.floatValue
                          thirdName:thirdName
                       thirdPercent:thirdPercent.floatValue
                              color:color];
            return cell;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.controllerMode == YMSummaryControllerModeNormal)
        return 164;
    else
        return self.tableView.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.controllerMode == YMSummaryControllerModeNormal) {
        NSInteger index = indexPath.row;
        if (index == YMSummaryCellVisitors || index == YMSummaryCellTime) {
            [[APPDELEGATE menuController] openTrafficSummaryController];
        } else if (index == YMSummaryCellSources) {
            [[APPDELEGATE menuController] openSourcesSummaryController];
        } else if (index == YMSummaryCellGeo) {
            [[APPDELEGATE menuController] openGeoController];
        } else if (index == YMSummaryCellGender || index == YMSummaryCellAge) {
            [[APPDELEGATE menuController] openDemographyController];
        } else if (index == YMSummaryCellOS) {
            [[APPDELEGATE menuController] openOSController];
        } else if (index == YMSummaryCellBrowsers) {
            [[APPDELEGATE menuController] openBrowsersController];
        }
    }
}


@end