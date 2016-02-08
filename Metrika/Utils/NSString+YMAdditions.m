//
// Created by Dmitry Korotchenkov on 13/11/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "NSString+YMAdditions.h"
#import "YMUtils.h"


@implementation NSString (YMAdditions)

-(CGSize)sizeForFont:(UIFont *)font {
    if (SYSTEM_VERSION_LESS_THAN_7) {
        return [self sizeWithFont:font];
    } else {
        return [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }
}

-(CGSize)sizeForFont:(UIFont *)font constrainedToSize:(CGSize)size{
    if (SYSTEM_VERSION_LESS_THAN_7) {
        return [self sizeWithFont:font constrainedToSize:size];
    } else {
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
}

@end