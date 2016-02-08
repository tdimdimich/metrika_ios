//
// Created by Dmitry Korotchenkov on 14/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMListControl : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)setColor:(UIColor *)color;

- (void)setData:(NSArray *)data selectedIndex:(NSUInteger)selectedIndex target:(NSObject *)target1 action:(SEL)action;

@end