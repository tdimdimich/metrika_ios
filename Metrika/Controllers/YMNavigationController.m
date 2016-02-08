//
// File: YMNavigationController.m
// Project: Metrika
//
// Created by dkorneev on 10/4/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMNavigationController.h"
#import "YMCounterListController.h"
#import "YMWebViewController.h"

@implementation YMNavigationController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController.class isEqual:[YMCounterListController class]] ||
            [viewController.class isEqual:[YMWebViewController class]]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

@end