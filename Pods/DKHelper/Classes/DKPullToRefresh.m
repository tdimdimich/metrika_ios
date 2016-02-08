//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <objc/runtime.h>
#import <DKHelper/UIView+DKViewAdditions.h>
#import "DKPullToRefresh.h"
#import "UIScrollView+DKAdditions.h"

#define PERFORM_DELEGATE_SELECTOR(selector) \
if (self.delegate && [self.delegate respondsToSelector:_cmd]) {\
    return [self.delegate selector];\
}

static char dk_kvoContext;

@interface DKPullToRefresh ()
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) id delegate;
@property(nonatomic, copy) void (^changeStateBlock)(UIView *, DKPullToRefreshState);
@property(nonatomic) DKPullToRefreshState currentState;
@property(nonatomic) float offsetForLoading;
@property(nonatomic) CGFloat topInset;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) BOOL isDragging;
@end

@implementation DKPullToRefresh


- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL b = [super respondsToSelector:aSelector];
    if (!b && self.delegate) {
        return [self.delegate respondsToSelector:aSelector];
    }
    return b;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (self.delegate && [self.delegate respondsToSelector:aSelector]) {
        return [[self.delegate class] instanceMethodSignatureForSelector:aSelector];
    } else {
        return [[super class] instanceMethodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (self.delegate && [self.delegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.delegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

- (id)initWithScrollView:(UIScrollView *)scrollView
              headerView:(UIView *)headerView
   offsetForStartLoading:(float)offsetForLoading
        changeStateBlock:(void (^)(UIView *view, DKPullToRefreshState))changeStateBlock {
    self = [super init];
    if (self) {
        self.offsetForLoading = offsetForLoading;
        self.scrollView = scrollView;
        self.changeStateBlock = changeStateBlock;
        _headerView = headerView;
        if (self.scrollView.delegate) {
            self.delegate = self.scrollView.delegate;
        }
        self.topInset = scrollView.topInset;
        self.scrollView.delegate = self;
        headerView.bottom = self.scrollView.topInset;
        [self.scrollView addSubview:headerView];
        self.currentState = DKPullToRefreshStateLoading;
        [self cancelLoading];
        [scrollView addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:&dk_kvoContext];
    }

    return self;
}

- (void)dealloc {
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"delegate" context:&dk_kvoContext];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &dk_kvoContext) {
        if (self.scrollView.delegate != self) {
            self.delegate = self.scrollView.delegate;
            self.scrollView.delegate = self;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)cancelLoading {
    self.isLoading = NO;
    [self updateHeaderForState:DKPullToRefreshStateHide];
}

- (void)updateHeaderForState:(DKPullToRefreshState)state {
    if (self.currentState != state && !self.isLoading) {
        DKPullToRefreshState previousState = self.currentState;
        self.currentState = state;
        if (state == DKPullToRefreshStateLoading) {
            self.isLoading = YES;
            CGFloat offset = self.scrollView.offsetY;
            self.scrollView.topInset = self.topInset + self.offsetForLoading;
            self.scrollView.offsetY = offset;
        } else if (previousState == DKPullToRefreshStateLoading) {
            CGFloat offset = self.scrollView.offsetY;
            self.scrollView.topInset = self.topInset;
            self.scrollView.offsetY = offset;
            if (self.scrollView.topInset + offset >= -self.headerView.height) {
                [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.topInset) animated:YES];
            }
        }
        self.changeStateBlock(self.headerView, state);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    PERFORM_DELEGATE_SELECTOR(scrollViewDidScroll:
    scrollView)

    if (self.topInset + scrollView.offsetY < -self.headerView.height) {
        self.headerView.top = self.topInset + scrollView.offsetY;
    } else {
        self.headerView.bottom = self.topInset;
    }

    if (self.isDragging) {
        CGFloat offset = self.scrollView.topInset + self.scrollView.offsetY;
        if (offset < 0) {
            if (offset < -self.offsetForLoading) {
                [self updateHeaderForState:DKPullToRefreshStateWillBeLoadingIfEndDragging];
            } else {
                [self updateHeaderForState:DKPullToRefreshStateNotWillBeLoadingIfEndDragging];
            }
        } else {
            [self updateHeaderForState:DKPullToRefreshStateHide];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    PERFORM_DELEGATE_SELECTOR(scrollViewDidEndDragging:
    scrollView
            willDecelerate:
    decelerate)

    self.isDragging = NO;

    CGFloat offset = self.scrollView.topInset + self.scrollView.offsetY;
    if (offset < 0) {
        if (offset < -self.offsetForLoading) {
            [self updateHeaderForState:DKPullToRefreshStateLoading];
        }
    }
}


@end