//
// File: YMSignInController.h
// Project: Metrika
//
// Created by dkorneev on 8/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "YMWebViewController.h"


@interface YMSignInController : UIViewController <YMWebViewControllerProtocol, TTTAttributedLabelDelegate>
- (void)didObtainToken:(NSString *)token;
@end