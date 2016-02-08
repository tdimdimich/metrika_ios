//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPullToRefresh.h"


@interface YMPullToRefreshHeaderView : UIView

+ (instancetype)createView;

- (void)setReloadTarget:(id)target action:(SEL)action;

- (void (^)(UIView *, DKPullToRefreshState))changeStateHandler;

@end