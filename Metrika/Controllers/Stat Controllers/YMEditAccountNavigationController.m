//
// Created by Dmitry Korotchenkov on 14/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMEditAccountNavigationController.h"
#import "YMUtils.h"


@implementation YMEditAccountNavigationController

+(instancetype)loadController {
    return [STORYBOARD instantiateViewControllerWithIdentifier:@"editAccountNavigationControllerID"];
}

@end