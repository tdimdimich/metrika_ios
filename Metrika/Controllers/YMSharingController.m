//
// File: YMSharingController.m
// Project: Metrika
//
// Created by dkorneev on 5/16/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import <VK-ios-sdk/VKPermissions.h>
#import <VK-ios-sdk/VKSdk.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "YMSharingController.h"
#import "YMConstants.h"

static NSString *kShareUrl = @"https://itunes.apple.com/ru/app/millimetrika/id840372237?mt=8";

@interface YMSharingController()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *vkButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation YMSharingController

- (void)viewDidLoad {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.facebookButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    self.twitterButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    self.messageButton.enabled = [MFMessageComposeViewController canSendText];

    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
    [self.messageButton setTitle:NSLocalizedString(@"Message-button-title", @"Сообщение") forState:UIControlStateNormal];

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.width = self.vkButton.right + self.messageButton.left;
    self.scrollView.contentSize = contentSize;

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (location.y < self.containerView.top) {
            if (self.delegate) {
                [self.delegate hideSharingView];
            }
        }
    }];
    [self.view addGestureRecognizer:gr];
}

#pragma mark user interactions

- (IBAction)abortButtonTap:(id)sender {
    if (self.delegate) {
        [self.delegate hideSharingView];
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

- (IBAction)mailButtonTap:(id)sender {
    NSString *sharingText = NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.");
    NSURL *shareUrl = [NSURL URLWithString:kShareUrl];
    NSString *messageBody = [sharingText stringByAppendingFormat:@"\n%@", shareUrl.absoluteString];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setMessageBody:messageBody isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)twButtonTap:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:NSLocalizedString(@"Sharing-Mesage-Text", @"Миллиметрика. Удобная аналитика.")];
    [controller addURL:[NSURL URLWithString:kShareUrl]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)fbButtonTap:(id)sender {
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