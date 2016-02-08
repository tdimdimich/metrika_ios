//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMDetailedElementModel;


// provided by YMDetailedInfoElementView.xib
static CGFloat kDetailedInfoElementViewHeight = 16;

@interface YMDetailedInfoElementView : UIView
+ (YMDetailedInfoElementView *)createView;

- (void)fillWithColor:(UIColor *)color model:(YMDetailedElementModel *)model;
@end