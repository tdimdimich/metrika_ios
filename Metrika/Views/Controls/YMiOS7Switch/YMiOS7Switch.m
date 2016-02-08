//
// Created by Dmitry Korotchenkov on 18.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMiOS7Switch.h"


static const int kLeftHandlerPosition = 0;

static const int kRightHandlerPosition = 21;

@interface YMiOS7Switch ()
@property(nonatomic, strong) UIImageView *switchHandler;
@property(nonatomic) CGFloat startRecognizerPosition;
@property(nonatomic, weak) id switchTarget;
@property(nonatomic) SEL switchAction;
@end

@implementation YMiOS7Switch

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSwitch];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createSwitch];
}

- (void)addSwitchChangeTarget:(id)target action:(SEL)action {
    self.switchTarget = target;
    self.switchAction = action;
}

- (void)createSwitch {
    self.backgroundColor = [UIColor clearColor];
    self.width = kiOS7SwitchWidth;
    self.height = kiOS7SwitchHeight;
    UIImageView *switchBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7-switch-bg.png"]];
    switchBG.left = 0;
    switchBG.top = 0;
    [self addSubview:switchBG];
    self.switchHandler = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7-switch-handle.png"]];
    self.switchHandler.left = 0;
    self.switchHandler.top = 0;
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)]];
    [self addSubview:self.switchHandler];
}

- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    [self animateToState:!self.selected];
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer {
    CGFloat translationX = [recognizer translationInView:self].x;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.startRecognizerPosition = translationX;
            break;
        case UIGestureRecognizerStateChanged : {
            CGFloat newX = self.switchHandler.left + translationX - self.startRecognizerPosition;
            newX = newX < kLeftHandlerPosition ? kLeftHandlerPosition : newX;
            newX = newX > kRightHandlerPosition ? kRightHandlerPosition : newX;
            self.switchHandler.left = newX;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            BOOL newState = self.switchHandler.left > (kRightHandlerPosition - kLeftHandlerPosition) / 2;
            [self animateToState:newState];
        }
        default:
            break;
    }

}

- (void)animateToState:(BOOL)state {
    [UIView animateFromCurrentStateWithDuration:0.2 animations:^{
        self.switchHandler.left = state ? kRightHandlerPosition : kLeftHandlerPosition;
    }                                completion:^(BOOL finished) {
        if (self.selected != state) {
            [self stateDidChange:state];
        }
    }];
}

- (void)stateDidChange:(BOOL)state {
    self.selected = state;
    if (self.switchTarget) {
        [self.switchTarget performSelector:self.switchAction withObject:self];
    }
}

@end