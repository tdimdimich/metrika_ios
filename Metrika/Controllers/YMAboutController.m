//
// Created by Dmitry Korotchenkov on 04/03/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMAboutController.h"
#import "YMUtils.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAI.h"
#import "Config.h"

static NSString *kShareUrl = @"https://itunes.apple.com/ru/app/millimetrika/id840372237?mt=8";

@interface YMAboutController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property(weak, nonatomic) IBOutlet UITableViewCell *shareCell;
@property(weak, nonatomic) IBOutlet UIButton *vkButton;
@property(weak, nonatomic) IBOutlet UIButton *facebookButton;
@property(weak, nonatomic) IBOutlet UIButton *twitterButton;
@property(weak, nonatomic) IBOutlet UIButton *mailButton;
@property(weak, nonatomic) IBOutlet UILabel *segalovichLabel;
@end

@implementation YMAboutController

+ (YMAboutController *)loadController {
    YMAboutController *controller = [STORYBOARD instantiateViewControllerWithIdentifier:@"aboutControllerID"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageButton setTitle:NSLocalizedString(@"Message-button-title", @"Сообщение") forState:UIControlStateNormal];
    self.segalovichLabel.text = NSLocalizedString(@"Segalovich", nil);
    self.facebookButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    self.twitterButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    self.messageButton.enabled = [MFMessageComposeViewController canSendText];

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.width = self.vkButton.right + self.messageButton.left;
    self.scrollView.contentSize = contentSize;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 20, 0);
}

- (IBAction)shareViaMailButtonTap:(id)sender {
    NSString *sharingText = NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.");
    NSURL *shareUrl = [NSURL URLWithString:kShareUrl];
    NSString *messageBody = [sharingText stringByAppendingFormat:@"\n%@", shareUrl.absoluteString];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setMessageBody:messageBody isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)twitterButtonTap:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.")];
    [controller addURL:[NSURL URLWithString:kShareUrl]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)facebookButtonTap:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.")];
    [controller addURL:[NSURL URLWithString:kShareUrl]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)vkButtonTap:(id)sender {
    [VKSdk initializeWithDelegate:self andAppId:kVKAppId];
    if ([VKSdk wakeUpSession]) {
        [self vkPostToWall];

    } else {
        [VKSdk authorize:@[VK_PER_WALL]];
    }
}

- (IBAction)messageButtonTap:(id)sender {
    NSString *sharingText = NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.");
    NSURL *shareUrl = [NSURL URLWithString:kShareUrl];

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.messageComposeDelegate = self;
    controller.body = [sharingText stringByAppendingFormat:@"\n%@", shareUrl.absoluteString];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkPostToWall {
    NSString *sharingText = NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.");
    NSURL *shareUrl = [NSURL URLWithString:kShareUrl];

    VKRequest *post = [[VKApi wall] post:@{VK_API_FRIENDS_ONLY : @(0),
            VK_API_OWNER_ID : [VKSdk getAccessToken].userId,
            VK_API_MESSAGE : sharingText,
            VK_API_ATTACHMENTS : [shareUrl absoluteString]
    }];
    [post executeWithResultBlock:^(VKResponse *response) {
    }                 errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)mailButtonTap {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"mailto:info@progress-engine.ru"]];
}

- (IBAction)siteButtonTap {
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"redirect action"
                                                          action:@"redirect to http://progress-engine.ru"
                                                           label:nil
                                                           value:nil] build]];
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://www.progress-engine.ru?utm_source=progress-engine&utm_campaign=MM_ios&utm_medium=crc"]];
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VKSdkDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [VKSdk authorize:@[VK_PER_WALL, VK_PER_PHOTOS]];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self vkPostToWall];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Access denied"
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end