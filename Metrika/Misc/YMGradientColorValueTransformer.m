//
// File: YMGradientColorValueTransformer.m
// Project: Metrika
//
// Created by dkorneev on 10/1/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMGradientColorValueTransformer.h"


@implementation YMGradientColorValueTransformer

+ (Class)transformedValueClass {
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

// Takes a YMGradientColor, returns an NSData
- (id)transformedValue:(id)value {
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

// Takes an NSData, returns a YMGradientColor
- (id)reverseTransformedValue:(id)value {
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end