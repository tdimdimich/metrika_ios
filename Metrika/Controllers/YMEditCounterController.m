//
// Created by Dmitry Korotchenkov on 30.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMEditCounterController.h"
#import "YMCircleColorButton.h"
#import "YMUtils.h"
#import "NSArray+BlocksKit.h"
#import "YMCounterInfo.h"
#import "YMCounterInfo.h"
#import "YMGradientColor.h"
#import "YMCircleView.h"
#import "YMAppSettings.h"
#import "UIViewController+YMBackButtonAddition.h"
#import "YMGradientColor.h"

static const CGFloat kLeftOffset = 24;
static const CGFloat kTopOffset = 22;
static const CGFloat kButtonsMargin = 34;

@interface YMEditCounterController ()
@property(nonatomic, strong) IBOutlet UIView *colorsContainerView;
@property(nonatomic, strong) IBOutlet YMCircleView *circleView;
@property(nonatomic, strong) IBOutlet UILabel *counterNameLabel;
@property(nonatomic, strong) NSArray *colorButtons;
@property(nonatomic, strong) NSArray *gradientColors;
@property(nonatomic, strong) YMGradientColor *selectedColor;
@end

@implementation YMEditCounterController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.counterNameLabel.text = self.counter.siteName;
    self.counterNameLabel.textColor = self.counter.color.startColor;
    self.circleView.selected = YES;
    self.circleView.color = self.counter.color.startColor;

    self.gradientColors = [YMUtils counterColors];
    NSArray *colors = self.gradientColors;
    self.selectedColor = self.counter.color;
    NSMutableArray *buttons = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.gradientColors.count; i++) {
        CGFloat xPosition = kLeftOffset + kButtonsMargin * (i % 9);
        CGFloat yPosition = kTopOffset + kButtonsMargin * (i / 9);
        YMGradientColor *color = [colors objectAtIndex:i];
        YMCircleColorButton *button = [YMCircleColorButton buttonWithCenterPosition:CGPointMake(xPosition, yPosition) color:color.startColor];
        button.tag = i;
        button.selected = [color isEqualToColor:self.selectedColor];
        [button addTarget:self action:@selector(didSelectColor:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        [self.colorsContainerView addSubview:button];
    }
    self.colorButtons = [NSArray arrayWithArray:buttons];
}

- (void)didSelectColor:(YMCircleColorButton *)selectedButton {
    [self.colorButtons bk_each:^(UIButton *button) {
        button.selected = [button isEqual:selectedButton];
    }];
    self.counterNameLabel.textColor = selectedButton.color;
    self.circleView.color = selectedButton.color;
    self.selectedColor = [self.gradientColors objectAtIndex:(NSUInteger) selectedButton.tag];
}

- (IBAction)confirmOk {
    self.counter.color = self.selectedColor;
    [YMAppSettings commitUpdates];
    [self back];

}

@end