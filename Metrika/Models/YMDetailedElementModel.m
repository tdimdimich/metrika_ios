//
// Created by Dmitry Korotchenkov on 18/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMDetailedElementModel.h"


@implementation YMDetailedElementModel

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value valueType:(NSString *)valueType percent:(CGFloat)percent {
    self = [super init];
    if (self) {
        self.title = title;
        self.value = value;
        self.percent = percent;
        self.valueType=valueType;
    }

    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title value:(NSString *)value valueType:(NSString *)valueType percent:(CGFloat)percent {
    return [[self alloc] initWithTitle:title value:value valueType:valueType percent:percent];
}


@end