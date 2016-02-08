//
// Created by Dmitry Korotchenkov on 30/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractInfoElementCell.h"


@interface YMDiagramInfoElementCell : YMAbstractInfoElementCell
- (void)fillWithTitle:(NSString *)title value:(CGFloat)value color:(UIColor *)color separatorColor:(UIColor *)separatorColor;

- (void)fillWithTitle:(NSString *)title value:(CGFloat)value color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor;
@end