//
// File: YMMessageActivity.h
// Project: Metrika
//
// Created by dkorneev on 5/16/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMMessageActivity : UIActivity <MFMessageComposeViewControllerDelegate>

- (id)initWithParent:(UIViewController *)parent;
@end