//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMStatAbstractController.h"
#import "YMCounterMenuController.h"
#import "YMAppSettings.h"
#import "YMAbstractEntity.h"
#import "NSArray+BlocksKit.h"
#import "YMCounter.h"
#import "YMTipsManager.h"
#import "DKPullToRefresh.h"
#import "YMPullToRefreshHeaderView.h"


@interface YMStatAbstractController ()
@property(nonatomic, strong) DKPullToRefresh *refresh;
@end

@implementation YMStatAbstractController

+ (YMStatAbstractController *)loadController {
    return [[self alloc] initWithNibName:@"YMStatAbstractController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kAppSettingsDidUpdateNotification object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

    YMPullToRefreshHeaderView *pullToRefreshView = [YMPullToRefreshHeaderView createView];
    [pullToRefreshView setReloadTarget:self action:@selector(updateData)];
    self.refresh = [[DKPullToRefresh alloc] initWithScrollView:self.tableView
                                                    headerView:pullToRefreshView
                                         offsetForStartLoading:pullToRefreshView.height
                                              changeStateBlock:pullToRefreshView.changeStateHandler];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self tableView] reloadData];
}

- (BOOL)canShowLandscapeMode {
    return ![self.menuController isShown];
}

- (void)updateData {
    YMCounterInfo *counterInfo = [YMAppSettings selectedCounter];
    YMCounter *counter = counterInfo.counter;
    if (!counter)
        return;
    self.dateStart = counterInfo.dateStart;
    self.dateEnd = counterInfo.dateEnd;
    self.controllerMode = YMStatControllerModeLoading;
    self.errorText = nil;

    [self updateDataSourceForCounter:counter
                             success:^() {
                                 self.controllerMode = YMStatControllerModeNormal;
                                 [self.refresh cancelLoading];
                                 [self.tableView reloadData];
                             }
                               error:^(NSError *error) {
                                   [self.refresh cancelLoading];
                                   self.controllerMode = YMStatControllerModeError;
                                   if ([[YMAbstractEntity codesForError:error] bk_any:^BOOL(NSString *obj) {
                                       return [YMAbstractEntity isCodeForPeriodError:obj];
                                   }]) {
                                       self.errorText = [YMAbstractEntity textForError:error];
                                   }
                                   [self.tableView reloadData];
                               }];
}

// must be overridden and needs to execute blocks in main queue (dispatch_async(dispatch_get_main_queue() ...)
- (void)updateDataSourceForCounter:(YMCounter *)counter success:(void (^)())success error:(void (^)(NSError *))failure {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark rotation and landscape view

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) && UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        [YMTipsManager didRotateScreen];
        self.isLandscapeMode = YES;
        self.view.top = 0;
        self.view.height = [APPDELEGATE window].width;
        self.contentView.width = [APPDELEGATE window].height;
        self.menuController.view.alpha = 0;
        self.contentView.top = 0;
        self.contentView.height = self.view.height;
        self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

    } else if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        self.isLandscapeMode = NO;
        self.view.top = SYSTEM_VERSION_LESS_THAN_7 ? 0 : 20;
        self.view.top = 20;
        self.view.height = [APPDELEGATE window].height - 20;
        self.contentView.width = [APPDELEGATE window].width;
        self.menuController.view.alpha = 1;
        self.contentView.top = self.menuController.minHeight;
        self.contentView.height = self.view.height - self.menuController.minHeight;
        self.tableView.scrollEnabled = YES;
        [self.tableView reloadData];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:UIInterfaceOrientationIsLandscape(toInterfaceOrientation) withAnimation:UIStatusBarAnimationSlide];
}

@end