//
// Created by Dmitry Korotchenkov on 13/11/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (YMAdditions)
- (CGSize)sizeForFont:(UIFont *)font;

- (CGSize)sizeForFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end