//
// Created by Dmitry Korotchenkov on 15/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMElementModel;

@interface YMGraphInfoElementView : UIView

+ (YMGraphInfoElementView *)createView;

- (void)fillWithModel:(YMElementModel *)model color:(UIColor *)color;

@end