//
// Created by Dmitry Korotchenkov on 06/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "NSNumber+YMAdditions.h"


@implementation NSNumber (YMAdditions)

- (NSNumber *)numberAddingFloatNumber:(NSNumber *)number {
    return [NSNumber numberWithFloat:(self.floatValue + number.floatValue)];
}

@end