//
// Created by Dmitry Korotchenkov on 05/05/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VK-ios-sdk/VKSdk.h>


static NSString *const kVKActivityType = @"VKActivityType";

@interface YMVKActivityItem : UIActivity <VKSdkDelegate>
- (id)initWithParent:(UIViewController *)parent;
@end