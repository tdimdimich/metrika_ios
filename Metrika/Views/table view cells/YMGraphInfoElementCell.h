//
// Created by Dmitry Korotchenkov on 30/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractInfoElementCell.h"


@interface YMGraphInfoElementCell : YMAbstractInfoElementCell

// models - array of YMElementModel; separatorColor - nil for default
- (void)fillWithTitle:(NSString *)title model:(YMElementModel *)model color:(UIColor *)color separatorColor:(UIColor *)separatorColor;

//separatorColor - nil for default
- (void)fillWithTitle:(NSString *)title model:(YMElementModel *)model color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor;

@end