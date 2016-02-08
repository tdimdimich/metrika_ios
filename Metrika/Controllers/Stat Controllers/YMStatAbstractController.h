//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMPlotView.h"

@protocol YMGraphDataSource;
@protocol YMPlotViewDelegate;
@class YMCounterMenuController;
@class YMCounter;
@class YMPlotView;
@class DKPullToRefresh;

typedef enum {
    YMStatControllerModeLoading,
    YMStatControllerModeNormal,
    YMStatControllerModeError,
} YMStatControllerMode;

@interface YMStatAbstractController : UIViewController

@property(nonatomic, strong) IBOutlet UIView *contentView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSDate *dateStart;
@property(nonatomic, strong) NSDate *dateEnd;
@property(nonatomic, strong) YMCounterMenuController *menuController;
@property(nonatomic, strong) YMPlotView *plotView;
@property(nonatomic) BOOL isLandscapeMode;

@property(nonatomic) YMStatControllerMode controllerMode;

@property(nonatomic, copy) NSString *errorText;

+ (YMStatAbstractController *)loadController;

- (void)updateData;

// must be overridden and needs to execute blocks in main queue (dispatch_async(dispatch_get_main_queue() ...)
- (void)updateDataSourceForCounter:(YMCounter *)counter success:(void (^)())success error:(void (^)(NSError *))failure;

@end