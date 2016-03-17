//
// File: YMSignInController.m
// Project: Metrika
//
// Created by dkorneev on 8/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Objection/Objection.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSignInController.h"
#import "YMCheckButton.h"
#import "YMProgressBarController.h"
#import "YMCountersListService.h"
#import "YMCounterListController.h"
#import "YMCounterInfo.h"
#import "YMAccountInfo.h"
#import "YMCountersListWrapper.h"
#import "YMUtils.h"
#import "YMAppSettings.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAI.h"
#import "TTTAttributedLabel.h"

static const CGFloat k4IncOffset = 282;
static const CGFloat k3and5IncOffset = 236;
static const float kShowHideProgressViewAnimationDuration = 0.25;

#define IS_4_INC_SCREEN ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_3_5_INC_SCREEN ([[UIScreen mainScreen] bounds].size.height == 480.0f)

@interface YMSignInController ()
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *offerLabel;
@property(weak, nonatomic) IBOutlet UIButton *rememberAccountButton;
@property(weak, nonatomic) IBOutlet UILabel *infoLabel;
@property(weak, nonatomic) IBOutlet UIButton *addAccountAdditionalButton;
@property(weak, nonatomic) IBOutlet UIButton *backAdditionalButton;
@property(weak, nonatomic) IBOutlet UIButton *addAccountButton;
@property(weak, nonatomic) IBOutlet UIButton *enterButton;
@property(weak, nonatomic) IBOutlet UIButton *accountButton;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet YMCheckButton *checkButton;
@property(weak, nonatomic) IBOutlet UIView *controlView;
@property(nonatomic, strong) YMProgressBarController *progressBarController;
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property(nonatomic, strong) YMCountersListService *counterListService;
@end

@implementation YMSignInController

objection_requires(@"counterListService")

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }
    return self;
}

- (void)showProgressViewAnimated:(BOOL)animated {
    [self setAlpha:1 forView:self.progressBarController.view animated:animated withDuration:kShowHideProgressViewAnimationDuration];
}

- (void)hideProgressViewAnimated:(BOOL)animated {
    [self setAlpha:0 forView:self.progressBarController.view animated:animated withDuration:kShowHideProgressViewAnimationDuration];
}

- (void)setAlpha:(CGFloat)alpha forView:(UIView *)view animated:(BOOL)animated withDuration:(CGFloat)duration {
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:animated ? duration : 0
                         animations:^{
                             view.alpha = alpha;
                         }
                         completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }];

    } else {
        view.alpha = alpha;
    }
}

- (void)setNextProgressStep {
    static NSUInteger progress = 0;
    if (progress >= 100) {
        [self.timer invalidate];

        // go to the next screen
        YMCounterListController *counterListController = [self.storyboard instantiateViewControllerWithIdentifier:@"counterListControllerID"];
        [self.navigationController pushViewController:counterListController animated:YES];
        [self hideProgressViewAnimated:YES];
        progress = 0;

        [self.progressBarController.view removeFromSuperview];
        [self.progressBarController removeFromParentViewController];
        [self createProgressView];
    };
    [self.progressBarController setProgress:++progress];
}

- (void)gotoCounterList {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(setNextProgressStep) userInfo:nil repeats:YES];
}

- (void)setBackgroundImage {
    
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    if ([language isEqualToString:@"ru-RU"]) {
        self.logoImageView.image = [UIImage imageNamed:@"millimetrika_loginscreen_logo"];
    } else {
        self.logoImageView.image = [UIImage imageNamed:@"millimetrika_loginscreen_logo_en"];
    }
    
    if (IS_4_INC_SCREEN) {
        self.logoTopConstraint.constant = 112;
//        self.imageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
//        CGRect frame = self.controlView.frame;
//        frame.origin.y = k4IncOffset;
//        self.controlView.frame = frame;

    } else if (IS_3_5_INC_SCREEN) {
        self.logoTopConstraint.constant = 96;
//        self.imageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    } else {
//        CGRect frame = self.controlView.frame;
//        frame.origin.y = k3and5IncOffset;
//        self.controlView.frame = frame;
//        self.imageView.image = [UIImage imageNamed:@"Default.png"];
    }
}

- (void)createProgressView {
    self.progressBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressBarController"];
    [self addChildViewController:self.progressBarController];
    [self.view addSubview:self.progressBarController.view];
    [self.view bringSubviewToFront:self.progressBarController.view];
    [self hideProgressViewAnimated:NO];
    self.controlView.alpha = 0;
}

- (void)configControls {
    self.enterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.addAccountAdditionalButton.width);
    self.addAccountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.backAdditionalButton.width);

    BOOL hasAccountYet = [YMAppSettings getAccounts].count > 0;
    if (hasAccountYet) {
        [self setEnterButtonVisible:YES addAccountButtonVisible:NO animated:NO];

    } else {
        [self setEnterButtonVisible:NO addAccountButtonVisible:NO animated:NO];
    }
}

- (void)setEnterButtonVisible:(BOOL)enterButtonVisible addAccountButtonVisible:(BOOL)addAccountButtonVisible animated:(BOOL)animated {
    CGFloat enterButtonAlpha = enterButtonVisible ? 1 : 0;
    CGFloat addAccountButtonAlpha = addAccountButtonVisible ? 1 : 0;
    CGFloat accountButtonAlpha = !(enterButtonVisible || addAccountButtonVisible) ? 1 : 0;

    __weak YMSignInController *weakSelf = self;
    void (^changeAlphaBlock)() = ^{
        weakSelf.accountButton.alpha = accountButtonAlpha;

        weakSelf.enterButton.alpha = weakSelf.addAccountAdditionalButton.alpha =
                weakSelf.infoLabel.alpha = enterButtonAlpha;

        weakSelf.addAccountButton.alpha = weakSelf.backAdditionalButton.alpha = addAccountButtonAlpha;

        weakSelf.rememberAccountButton.alpha = weakSelf.checkButton.alpha = accountButtonAlpha || addAccountButtonAlpha;
    };

    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateFromCurrentStateWithDuration:0.3 animations:changeAlphaBlock completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];

    } else {
        changeAlphaBlock();
    }
}

- (void)enter {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; // will end ignoring interaction in navigation's controller delegate
    [self showProgressViewAnimated:YES];
    [self gotoCounterList];
}

- (void)addAccountWithToken:(NSString *)token andCounters:(NSSet *)counters {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;

    NSMutableSet *countersSet = [NSMutableSet new];
    for (YMCounter *counter in counters) {
        YMCounterInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"YMCounterInfo" inManagedObjectContext:context];
        info.color = [YMUtils createCounterColorWithAlreadyExistingCounters:countersSet];
        info.counter = counter;
        info.dateStart = info.dateEnd = [NSDate date];
        [countersSet addObject:info];
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"YMAccountInfo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"token = %@", token];
    NSArray *existingAccounts = [context executeFetchRequest:fetchRequest error:nil];
    YMAccountInfo *accountInfo = nil;
    if (existingAccounts.count) {
        NSLog(@"account already exist");
        accountInfo = existingAccounts.firstObject;

    } else {
        NSLog(@"creating new account");
        accountInfo = [NSEntityDescription insertNewObjectForEntityForName:@"YMAccountInfo" inManagedObjectContext:context];
        accountInfo.name = [YMUtils createAccountName];
        accountInfo.token = token;
    }
    accountInfo.shouldBeRemoved = !self.checkButton.selected;
    accountInfo.counterInfo = countersSet;

    [YMAppSettings commitUpdates];
}

- (void)authAndEnter {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; // will end ignoring interaction in navigation's controller delegate
    YMWebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewControllerId"];
    webViewController.delegate = self;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark YMWebViewControllerProtocol

- (void)didObtainToken:(NSString *)token { // get counters and add new account
    [self showProgressViewAnimated:NO];

    __weak YMSignInController *weakSelf = self;
    void (^success)(YMCountersListWrapper *) = ^(YMCountersListWrapper *content) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"login/logout action"
                                                              action:@"login"
                                                               label:nil
                                                               value:nil] build]];

        [weakSelf addAccountWithToken:token andCounters:content.counters];
        [weakSelf gotoCounterList];
    };

    void (^failure)(NSError *) = ^(NSError *error) {
        NSLog(@"counterListService failure");
        [weakSelf.progressBarController.view removeFromSuperview];
        [weakSelf.progressBarController removeFromParentViewController];
        [weakSelf createProgressView];
        [weakSelf configControls];
        if (!weakSelf.controlView.alpha) {
            [UIView animateWithDuration:1 animations:^{
                weakSelf.controlView.alpha = 1;
            }];
        }
    };

    void (^downloadBlock)(NSUInteger, long long, long long) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSUInteger progress = (NSUInteger) (totalBytesExpectedToRead / totalBytesRead * 100);
        [weakSelf.progressBarController setProgress:progress];
    };

    [self.counterListService getCountersWithToken:token successBlock:success failureBlock:failure progressBlock:downloadBlock];
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // пока отключен мультиаккаунтинг и настройки сохранения учетной записи
    self.rememberAccountButton.hidden = self.checkButton.hidden = YES;

    [self setBackgroundImage];
    [self createProgressView];

    [self.accountButton setTitle:NSLocalizedString(@"Учетная запись Яндекс.Метрики", @"Учетная запись Яндекс.Метрики") forState:UIControlStateNormal];
    self.offerLabel.text = NSLocalizedString(@"OfferAgreement", @"I agree to the terms of this offer\ndue to continue to the application.");

    NSNumber* underline = [NSNumber numberWithInt:kCTUnderlineStyleThick|kCTUnderlinePatternDot];
    self.offerLabel.linkAttributes = @{
            NSForegroundColorAttributeName : [UIColor colorWithRed:210.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1],
            (NSString*)kCTUnderlineStyleAttributeName : underline
    };
    self.offerLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.offerLabel.delegate = self;
    NSRange range = [self.offerLabel.text rangeOfString:NSLocalizedString(@"OfferLinkText", @"оферты")];
    [self.offerLabel addLinkToURL:[NSURL URLWithString:@"http://progress-engine.ru/"] withRange:range];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.controlView.alpha) {
        [UIView animateWithDuration:1 animations:^{
            self.controlView.alpha = 1;
        }];
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark user interactions

- (IBAction)enterButtonTap:(id)sender {
    [self enter];
}

- (IBAction)backAdditionalButtonTap:(id)sender {
    [self setEnterButtonVisible:YES addAccountButtonVisible:NO animated:YES];
}

- (IBAction)addAccountButtonTap:(id)sender {
    [self authAndEnter];
}

- (IBAction)addAccountAdditionalButtonTap:(id)sender {
    [self setEnterButtonVisible:NO addAccountButtonVisible:YES animated:YES];
}

- (IBAction)rememberButtonTap:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
}

- (IBAction)signInButtonTap:(id)sender {
    [self authAndEnter];
}

@end