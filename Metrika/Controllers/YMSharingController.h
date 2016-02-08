//
// File: YMSharingController.h
// Project: Metrika
//
// Created by dkorneev on 5/16/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <VK-ios-sdk/VKSdk.h>

@protocol YMSharingControllerDelegate <NSObject>
- (void)hideSharingView;
@end

@interface YMSharingController : UIViewController <MFMailComposeViewControllerDelegate, VKSdkDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) id<YMSharingControllerDelegate> delegate;
@end