//
// Created by Dmitry Korotchenkov on 27/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMPullToRefreshHeaderView.h"

@interface YMPullToRefreshHeaderView ()
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic, strong) IBOutlet UIImageView *arrowImageView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) id target;
@property(nonatomic) SEL action;
@end

@implementation YMPullToRefreshHeaderView

+ (instancetype)createView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMPullToRefreshHeaderView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activityView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    self.titleLabel.text = NSLocalizedString(@"Pull down to refresh", @"Для обновления потяните вниз");
}

- (void)setReloadTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

- (void)reload {
    if (self.target && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action];
    }
}

- (void)animate:(void (^)())block {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         block();
                     }
                     completion:nil];
}

- (void (^)(UIView *, DKPullToRefreshState))changeStateHandler {
    __weak YMPullToRefreshHeaderView *weakSelf = self;
    return ^(UIView *headerView, DKPullToRefreshState state) {
        if (state == DKPullToRefreshStateNotWillBeLoadingIfEndDragging) {
            weakSelf.arrowImageView.hidden = NO;
            weakSelf.activityView.hidden = YES;
            weakSelf.titleLabel.text = NSLocalizedString(@"Pull down to refresh", @"Для обновления потяните вниз");
            [weakSelf animate:^{
                weakSelf.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }];
        } else if (state == DKPullToRefreshStateWillBeLoadingIfEndDragging) {
            weakSelf.arrowImageView.hidden = NO;
            weakSelf.activityView.hidden = YES;
            weakSelf.titleLabel.text = NSLocalizedString(@"Release to refresh", @"Отпустите, чтобы обновить...");
            [weakSelf animate:^{
                weakSelf.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        } else if (state == DKPullToRefreshStateLoading) {
            weakSelf.arrowImageView.hidden = YES;
            weakSelf.activityView.hidden = NO;
            [weakSelf.activityView startAnimating];
            weakSelf.titleLabel.text = NSLocalizedString(@"Retrieving data from server", @"Получение данных от сервера...");
            [weakSelf animate:^{
                weakSelf.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }];
            [weakSelf reload];
        }
    };
}

@end