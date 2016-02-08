//
// File: YMCounterMenuController.m
// Project: Metrika
//
// Created by dkorneev on 8/21/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMCounterMenuController.h"
#import "YMCircleView.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "YMAppSettings.h"
#import "NSArray+BlocksKit.h"
#import "YMGradientColor.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "YMConstants.h"

static const CGFloat kOpenCloseAnimationDuration = 0.4;
static const CGFloat kContentViewAnimationDuration = 0.3;

@interface YMCounterMenuController ()
@property(weak, nonatomic) IBOutlet UIImageView *shadowView;
@property(weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UILabel *selectedCounterLabel;
@property(weak, nonatomic) IBOutlet UIView *controlView;
@property(weak, nonatomic) IBOutlet YMCircleView *circleView;
@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UIButton *maximizeButton;
@property(weak, nonatomic) IBOutlet UIButton *minimizeButton;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, strong) YMCounterTableController *counterTableController;
@end

@implementation YMCounterMenuController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateCountersNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update {
    self.counterTableController.accounts = [YMAppSettings getAccounts];
    [self updateControls];
    [self updateContentViewHeightAnimated:NO];
    [self minimizeAnimated:NO];
}

- (void)viewDidLoad {
    _isShown = YES;
    self.counterTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CounterTableController"];
    self.counterTableController.cellType = YMCounterTableCellTypeWithDatePicker;
    self.counterTableController.accounts = [YMAppSettings getAccounts];
    self.counterTableController.delegate = self;
    [self addChildViewController:self.counterTableController];
    [self.containerView addSubview:self.counterTableController.view];

    [self updateControls];
    [self configureGestureRecognizers];
}

- (CGFloat)calcContentViewHeight {
    CGFloat resultHeight = self.counterTableController.contentHeight + self.controlView.height;
    CGFloat maxHeight = [[UIScreen mainScreen] applicationFrame].size.height - self.tabBarController.tabBar.frame.size.height;
    if (resultHeight > maxHeight) resultHeight = maxHeight;
    return resultHeight;
}

- (void)updateContentViewHeightAnimated:(BOOL)animated {
    CGFloat resultHeight = [self calcContentViewHeight];
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:kContentViewAnimationDuration
                         animations:^{
                             self.contentView.height = resultHeight;
                         }
                         completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];

    } else {
        self.contentView.height = resultHeight;
    }
}

- (void)setControlsAlpha:(CGFloat)alpha {
    self.maximizeButton.alpha = self.circleView.alpha = self.selectedCounterLabel.alpha = alpha;
    self.minimizeButton.alpha = self.confirmButton.alpha = self.shadowView.alpha = 1 - alpha;
}

- (void)updateControls {
    YMCounterInfo *selectedCounter = [YMAppSettings selectedCounter];
    [self.circleView setColor:selectedCounter.color.startColor];
    [self.circleView setSelected:YES];
    self.selectedCounterLabel.text = selectedCounter.siteName;
    self.selectedCounterLabel.textColor = selectedCounter.color.startColor;
}

- (void)maximizeAnimatedWithDuration:(CGFloat)animationDuration {
    _isShown = YES;
    CGRect newFrame = self.contentView.frame;
    newFrame.origin.y = 0;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.contentView.frame = newFrame;
                         [self setControlsAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

- (void)minimizeAnimatedWithDuration:(CGFloat)animationDuration {
    _isShown = NO;
    CGRect newFrame = self.contentView.frame;
    newFrame.origin.y = self.minViewY;
    if (animationDuration) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.contentView.frame = newFrame;
                             [self setControlsAlpha:1];
                         }
                         completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];
    } else {
        self.contentView.frame = newFrame;
        [self setControlsAlpha:1];
    }
    [self.counterTableController settingsWillCommitUpdates];
    [YMAppSettings commitUpdates];
}

- (void)maximizeAnimated:(BOOL)animated {
    [self maximizeAnimatedWithDuration:animated ? kOpenCloseAnimationDuration : 0];
}

- (void)minimizeAnimated:(BOOL)animated {
    [self minimizeAnimatedWithDuration:animated ? kOpenCloseAnimationDuration : 0];
}

- (CGFloat)minViewY {
    // add [self minHeight] because we should show half of control view in minimized state
    return -([self calcContentViewHeight]) + [self minHeight];
}

- (CGFloat)minHeight {
    return self.controlView.height / 2;
}

- (void)configureGestureRecognizers {
    __weak YMCounterMenuController *weakSelf = self;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
        static BOOL topDirection = NO;
        switch (state) {
            case UIGestureRecognizerStateChanged: {
                CGPoint translation = [recognizer translationInView:weakSelf.contentView];
                CGFloat newY = weakSelf.contentView.top + translation.y;
                topDirection = (newY < weakSelf.contentView.top);
                if (newY >= 0) {
                    weakSelf.contentView.top = 0;
                    [weakSelf setControlsAlpha:0];

                } else if (newY <= weakSelf.minViewY) {
                    weakSelf.contentView.top = weakSelf.minViewY;
                    [weakSelf setControlsAlpha:1];

                } else {
                    CGFloat alpha = ABS(weakSelf.contentView.top / weakSelf.minViewY);
                    [weakSelf setControlsAlpha:alpha];
                    weakSelf.contentView.top = newY;
                }
                [recognizer setTranslation:CGPointMake(0, 0) inView:weakSelf.contentView];
                break;
            }

            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded: {
                static CGFloat multiplier = 1.2;
                CGPoint velocityInView = [recognizer velocityInView:weakSelf.contentView];
                if (topDirection) {
                    CGFloat animationDuration = ABS((weakSelf.minViewY - weakSelf.contentView.top) / velocityInView.y);
                    animationDuration *= multiplier; // move slowly than velocity tell us
                    [weakSelf minimizeAnimatedWithDuration:animationDuration > kOpenCloseAnimationDuration ?
                            kOpenCloseAnimationDuration : animationDuration];

                } else { // down direction
                    CGFloat animationDuration = ABS(weakSelf.contentView.top / velocityInView.y);
                    animationDuration *= multiplier; // move slowly than velocity tell us
                    [weakSelf maximizeAnimatedWithDuration:animationDuration > kOpenCloseAnimationDuration ?
                            kOpenCloseAnimationDuration : animationDuration];
                }
                break;
            }

            default:
                break;
        }
    }];
    [self.controlView addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateContentViewHeightAnimated:NO];
}

#pragma mark YMCounterTableControllerProtocol

- (void)didSelectCounter {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"counter action"
                                                          action:@"change counter"
                                                           label:nil
                                                           value:nil] build]];
    [self updateControls];
}

#pragma mark user interactions

- (IBAction)confirmButtonTap:(id)sender {
    [self minimizeAnimated:YES];
}

- (IBAction)maximizeButtonTap:(id)sender {
    [self maximizeAnimated:YES];
}

- (IBAction)minimizeButtonTap:(id)sender {
    [self minimizeAnimated:YES];
}

@end