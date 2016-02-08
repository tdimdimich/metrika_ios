//
// Created by Dmitry Korotchenkov on 04/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMValueTypeStringFormat : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *type;

+ (YMValueTypeStringFormat *)formatWithValue:(NSString *)value type:(NSString *)type;

+ (YMValueTypeStringFormat *)formatFromFloatValue:(CGFloat)value;

+ (YMValueTypeStringFormat *)timeFormatFromSeconds:(NSInteger)seconds;

- (NSString *)combinedString;
@end