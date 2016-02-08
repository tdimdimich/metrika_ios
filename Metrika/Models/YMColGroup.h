//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMColGroup : NSObject

@property (nonatomic) CGFloat groupXValue;

// array on NSNumber
@property (nonatomic) NSArray *groupValues;

- (id)initWithGroupXValue:(CGFloat)groupXValue groupValues:(NSArray *)groupValues;

+ (id)groupWithGroupXValue:(CGFloat)groupXValue groupValues:(NSArray *)groupValues;

- (CGFloat)maxYValue;
@end