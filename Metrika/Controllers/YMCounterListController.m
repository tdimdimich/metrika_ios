//
// File: YMCounterListController.m
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <RestKit/RestKit/CoreData/RKManagedObjectStore.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMCounterListController.h"
#import "YMCounterInfo.h"
#import "YMAppSettings.h"
#import "YMMenuController.h"
#import "YMDatePickerController.h"
#import "YMUtils.h"
#import "YMAccountInfo.h"

@interface YMCounterListController ()
@property(weak, nonatomic) IBOutlet UIImageView *shadow;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(weak, nonatomic) IBOutlet UILabel *informationLabel;
@property(nonatomic, strong) YMCounterTableController *counterTableController;
@end

@implementation YMCounterListController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    return self;
}

- (void)viewDidLoad {
    self.counterTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CounterTableController"];
    self.counterTableController.accounts = [YMAppSettings getAccounts];
    self.counterTableController.delegate = self;
    [self addChildViewController:self.counterTableController];
    [self.containerView addSubview:self.counterTableController.view];

    // Show label, if visible sites count equal to 0.
    self.informationLabel.hidden = YES;
    NSUInteger visibleSites = 0;
    for (YMAccountInfo *accountInfo in [YMAppSettings getAccounts]) {
        visibleSites += [accountInfo visibleCountersInfo].count;
    }
    
    if (visibleSites == 0) {
        self.informationLabel.text = NSLocalizedString(@"Add sites to your account.", @"Добавьте сайты на аккаунт.");
        self.informationLabel.hidden = NO;
    }
    
    [self updateControls];
    self.shadow.hidden = self.counterTableController.contentHeight <= self.containerView.height;

    if (!SYSTEM_VERSION_LESS_THAN_7) {
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        blackView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackView];
    }
}

- (void)updateControls {
    if ([YMAppSettings selectedCounter]) {
        self.confirmButton.enabled = YES;
    }
}

#pragma mark YMCounterTableControllerProtocol

- (void)didSelectCounter {
    [self updateControls];
}

#pragma mark user interactions

- (IBAction)confirmButtonTap:(id)sender {
    [YMAppSettings commitUpdates];

    __weak YMCounterListController *weakSelf = self;
    YMDatePickerController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"datePickerControllerId"];
    controller.counter = [YMAppSettings selectedCounter];
    controller.confirmBlock = ^(NSDate *dateStart, NSDate *dateEnd) {
        [YMAppSettings selectedCounter].dateStart = dateStart;
        [YMAppSettings selectedCounter].dateEnd = dateEnd;
        [YMAppSettings commitUpdates];
        YMMenuController *menuController = APPDELEGATE.menuController;
        [weakSelf.navigationController pushViewController:menuController animated:YES];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

@end