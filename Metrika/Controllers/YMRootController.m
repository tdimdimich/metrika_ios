//
// File: YMRootController.m
// Project: Metrika
//
// Created by dkorneev on 9/19/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMRootController.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "YMUtils.h"

static const CGFloat kFilterMenuWidth = 277.0;
static const float kFilterMenuDuration = 0.3; // show/high filter menu animation duration

@interface YMRootController ()
@property(weak, nonatomic) IBOutlet UIView *shadowView;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation YMRootController

- (void)showFilterMenu {
    [self moveView:kFilterMenuWidth];
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = NO;
    }];
    self.tapGestureRecognizer.enabled = YES;
}

- (void)hideFilterMenu {
    [self moveView:0];
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = YES;
    }];
    self.tapGestureRecognizer.enabled = NO;
}

- (BOOL)isMenuShown {
    return self.view.left != 0;
}

- (void)showController:(UIViewController *)controller {
    
    controller.view.bounds = CGRectMake(0, 0, controller.view.width, controller.view.height);
    static NSInteger frameTopOffset = 0;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        frameTopOffset = SYSTEM_VERSION_LESS_THAN_7 ? 0 : 20;
    });
    
    controller.view.frame = CGRectMake(0, frameTopOffset, self.view.width, self.view.height - frameTopOffset);
    [self addChildViewController:controller];
    controller.view.alpha = 0;
    [self.view addSubview:controller.view];
    [self.view bringSubviewToFront:self.shadowView];

    if (self.isMenuShown) {
        [self hideFilterMenu];
    }

    [UIView animateWithDuration:kFilterMenuDuration
                     animations:^{
                         controller.view.alpha = 1;
                         self.activeController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (self.activeController.view) {
                             [self.activeController.view removeFromSuperview];
                             [self.activeController removeFromParentViewController];
                         }
                         _activeController = controller;
                     }];
}

- (void)moveView:(CGFloat)leftValue {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:kFilterMenuDuration
                     animations:^{
                         self.view.left = leftValue;
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         self.shadowView.hidden = self.view.left == 0;
                     }];
}

- (void)configureGestureRecognizers {
    __weak YMRootController *weakSelf = self;

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakSelf hideFilterMenu];
    }];
    self.tapGestureRecognizer.enabled = NO;

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
        static BOOL right = NO;
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                [YMUtils hideKeyboard];
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGPoint translation = [recognizer translationInView:weakSelf.view];
                CGFloat newX = weakSelf.view.left + translation.x;
                right = weakSelf.view.left < newX;
                if (newX < 0) {
                    weakSelf.view.left = 0;

                } else if (newX > kFilterMenuWidth) {
                    static const float multiplier = 0.5;
                    weakSelf.view.left += translation.x * multiplier; // move to right slowly, when we reached border

                } else {
                    weakSelf.view.left = newX;
                }
                [recognizer setTranslation:CGPointMake(0, 0) inView:weakSelf.view];
                weakSelf.shadowView.hidden = weakSelf.view.left == 0;
                break;
            }

            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded: {
                if (right) {
                    if (weakSelf.view.left > 0 && ABS(weakSelf.view.left) > kFilterMenuWidth / 5) {
                        [weakSelf showFilterMenu];
                    } else {
                        [weakSelf hideFilterMenu];
                    }

                } else {
                    if (weakSelf.view.left < kFilterMenuWidth * 4 / 5) {
                        [weakSelf hideFilterMenu];
                    } else {
                        [weakSelf showFilterMenu];
                    }
                }
                break;
            }
            default:
                break;
        }
    }];

    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [self configureGestureRecognizers];
    self.shadowView.hidden = self.view.left == 0;
    self.view.layer.masksToBounds = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIViewController *controller in self.childViewControllers) {
        controller.view.top = 0;
        controller.view.width = self.view.width;
        controller.view.height = self.view.height;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.panGestureRecognizer.enabled = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}


@end