//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


static const int kSummaryBrowsersCellElementHeight = 27;

@interface YMSummaryBrowsersCellElement : UIView
+ (instancetype)createView;

- (void)fillWithBrowserName:(NSString *)browserName percent:(CGFloat)percent color:(UIColor *)color;
@end