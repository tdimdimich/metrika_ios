//
// Created by Dmitry Korotchenkov on 04/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMValueTypeStringFormat.h"


@implementation YMValueTypeStringFormat

+ (YMValueTypeStringFormat *)formatWithValue:(NSString *)value type:(NSString *)type {
    YMValueTypeStringFormat *format = [[self alloc] init];
    format.value = value;
    format.type = type;
    return format;
}

+ (YMValueTypeStringFormat *)formatFromFloatValue:(CGFloat)value {
    NSString *(^roundBlock)(CGFloat) = ^(CGFloat val) {
        if (roundf(val) != val) {
            if (round(value) < 10) { // only if value < 10
                return [NSString stringWithFormat:@"%0.2f", round(val * 100) / 100.0f];
            } else {
                return [NSString stringWithFormat:@"%0.1f", round(val * 10) / 10.0f];
            }
        } else {
            return [NSString stringWithFormat:@"%0.0f", val];
        }
    };
    if (value < 1000)
        return [self formatWithValue:roundBlock(value) type:nil];
    else if (value < 1000000)
        return [self formatWithValue:roundBlock(value / 1000.0f) type:NSLocalizedString(@"VF-thousands", @"тыс")];
    else if (value < 1000000000)
        return [self formatWithValue:roundBlock(value / 1000000.0f) type:NSLocalizedString(@"VF-millions", @"млн")];
    else
        return [self formatWithValue:@"999+" type:NSLocalizedString(@"VF-millions", @"млн")];
}

//если только секунды (00:00:ХХ), то: ХХсек
//если есть минуты (00:ХХ:ХХ), то: ХХ:ХХ мин
//если есть часы (ХХ:ХХ:ХХ), то: ХХ:XXч

+ (YMValueTypeStringFormat *)timeFormatFromSeconds:(NSInteger)seconds {

    static int minute = 60;
    static int hour = 60 * 60;
    static int day = 24 * 60 * 60;

    YMValueTypeStringFormat *format = [[self alloc] init];
    if (seconds < minute) {
        format.value = [NSString stringWithFormat:@"%i", seconds];
        format.type = NSLocalizedString(@"VF-seconds", @"сек");

    } else if (seconds < hour) {
        NSInteger firstPart = seconds / minute;
        NSInteger secondPart = (seconds % minute) * 10 / minute;
        if (secondPart == 0) {
            format.value = [NSString stringWithFormat:@"%i", firstPart];
        } else {
            format.value = [NSString stringWithFormat:@"%i.%i", firstPart, secondPart];
        }
        format.type = NSLocalizedString(@"VF-minutes", @"мин");

    } else if (seconds < day) {
        NSInteger firstPart = seconds / hour;
        NSInteger secondPart = (seconds % hour) * 10 / hour;
        if (secondPart == 0) {
            format.value = [NSString stringWithFormat:@"%i", firstPart];
        } else {
            format.value = [NSString stringWithFormat:@"%i.%i", firstPart, secondPart];
        }
        format.type = NSLocalizedString(@"VF-hours", @"ч");

    } else {
        NSInteger firstPart = seconds / day;
        NSInteger secondPart = (seconds % day) * 10 / day;
        if (secondPart == 0) {
            format.value = [NSString stringWithFormat:@"%i", firstPart];
        } else {
            format.value = [NSString stringWithFormat:@"%i.%i", firstPart, secondPart];
        }
        format.type = NSLocalizedString(@"VF-days", @"д");
    }
    return format;
}

- (NSString *)combinedString {
    return [NSString stringWithFormat:@"%@%@", self.value, self.type ?: @""];
}

@end