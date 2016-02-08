//
// Created by Dmitry Korotchenkov on 25.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIViewController+YMBackButtonAddition.h"


@implementation UIViewController (YMBackButtonAddition)

- (IBAction)back {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end