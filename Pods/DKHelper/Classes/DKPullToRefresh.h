//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DKPullToRefreshStateHide,
    DKPullToRefreshStateNotWillBeLoadingIfEndDragging,
    DKPullToRefreshStateWillBeLoadingIfEndDragging,
    DKPullToRefreshStateLoading

} DKPullToRefreshState;

@interface DKPullToRefresh : NSObject <UIScrollViewDelegate>

- (id)initWithScrollView:(UIScrollView *)scrollView
              headerView:(UIView *)headerView
   offsetForStartLoading:(float)offsetForLoading
        changeStateBlock:(void (^)(UIView *view, DKPullToRefreshState))changeStateBlock;

@property(nonatomic, strong, readonly) UIView *headerView;

- (void)cancelLoading;

@end