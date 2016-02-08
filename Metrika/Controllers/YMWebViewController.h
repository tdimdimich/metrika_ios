//
// File: YMWebViewController.h
// Project: Metrika
//
// Created by dkorneev on 10/3/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol YMWebViewControllerProtocol
@optional
- (void)didObtainToken:(NSString *)token;
@end

@interface YMWebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) NSObject<YMWebViewControllerProtocol> *delegate;
@end