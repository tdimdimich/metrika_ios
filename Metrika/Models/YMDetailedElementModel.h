//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YMDetailedElementModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *valueType;
@property (nonatomic) CGFloat percent;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value valueType:(NSString *)valueType percent:(CGFloat)percent;

+ (instancetype)modelWithTitle:(NSString *)title value:(NSString *)value valueType:(NSString *)valueType percent:(CGFloat)percent;

@end