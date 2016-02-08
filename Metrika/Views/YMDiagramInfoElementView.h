//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMDiagramInfoElementView : UIView
+ (YMDiagramInfoElementView *)createView;

- (void)fillWithValue:(CGFloat)value color:(UIColor *)color;
@end