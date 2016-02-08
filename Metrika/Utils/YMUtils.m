//
// Created by Dmitry Korotchenkov on 26.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/Network/RKObjectManager.h>
#import <RestKit/RestKit/CoreData/RKManagedObjectStore.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import <BlocksKit/NSSet+BlocksKit.h>
#import "YMUtils.h"
#import "DKUtils.h"
#import "YMAccountInfo.h"
#import "YMCounterInfo.h"
#import "YMGradientColor.h"
#import "UIImage+DKAdditions.h"

YMInterval YMIntervalMake(float start, float end) {
    YMInterval interval;
    interval.intervalStart = start;
    interval.intervalEnd = end;
    return interval;
}

NSComparisonResult floatCompare(float value1, float value2) {
    if (value1 > value2)
        return NSOrderedDescending;
    else if (value1<value2)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

@implementation YMUtils

+ (BOOL)isPreferredRussianLanguage {
    for (NSString *string in [NSLocale preferredLanguages]) {
        if ([string isEqualToString:@"en"]) {
            return NO;

        } else if ([string isEqualToString:@"ru"]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)createAccountName {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"YMAccountInfo"];
    NSArray *existingAccounts = [context executeFetchRequest:fetchRequest error:nil];

    NSString *base = @"Учетная запись";
    NSString *var = nil;
    NSUInteger counter = 0;
    while (true) {
        var = [NSString stringWithFormat:@"%@ %d", base, ++counter];
        YMAccountInfo *match = [existingAccounts bk_match:^BOOL(YMAccountInfo *info) {
            return [info.name isEqualToString:var];
        }];
        if (!match)
            return var;
    }
}

+ (YMGradientColor *)createCounterColorWithAlreadyExistingCounters:(NSSet *)counters {
    YMGradientColor *var = nil;
    NSArray *colors = [self counterColors];

    int array[colors.count];
    memset(array, 0, sizeof(int));
    for (NSUInteger i = 0; i < colors.count; ++i) {
        var = colors[i];
        array[i] = [counters bk_select:^BOOL(YMCounterInfo *info) {
            return [info.color isEqualToColor:var];
        }].count;
    }

    NSUInteger indexForMinValue = 0;
    for (NSUInteger i = 1; i < colors.count; ++i) {
        if (array[i] < array[indexForMinValue]) {
            indexForMinValue = i;
        }
    }

    return colors[indexForMinValue];
}

+ (NSInteger)daysFrom:(NSDate *)date1 to:(NSDate *)date2 {
    return [self daysBetween:date1 :date2] + 1;
}

+ (NSInteger)daysBetween:(NSDate *)date1 :(NSDate *)date2 {
    NSUInteger day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date1];
    NSUInteger day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date2];
    return abs(day1 - day2);
}

+ (NSArray *)counterColors {
    static NSArray *colors;
    static dispatch_once_t t = 0;
    dispatch_once(&t, ^{
        colors = @[
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:232 green:38 blue:38] endColor:[DKUtils colorWithRed:199 green:47 blue:47]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:323 green:38 blue:111] endColor:[DKUtils colorWithRed:194 green:46 blue:102]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:225 green:38 blue:232] endColor:[DKUtils colorWithRed:188 green:42 blue:94]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:148 green:38 blue:232] endColor:[DKUtils colorWithRed:132 green:40 blue:202]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:60 green:71 blue:217] endColor:[DKUtils colorWithRed:67 green:80 blue:183]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:38 green:152 blue:232] endColor:[DKUtils colorWithRed:46 green:133 blue:194]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:38 green:211 blue:232] endColor:[DKUtils colorWithRed:37 green:174 blue:191]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:155 green:233 blue:33] endColor:[DKUtils colorWithRed:134 green:197 blue:36]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:232 green:161 blue:38] endColor:[DKUtils colorWithRed:195 green:137 blue:34]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:128 green:118 blue:238] endColor:[DKUtils colorWithRed:104 green:97 blue:186]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:127 green:163 blue:203] endColor:[DKUtils colorWithRed:94 green:125 blue:160]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:56 green:187 blue:123] endColor:[DKUtils colorWithRed:43 green:143 blue:94]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:52 green:232 blue:27] endColor:[DKUtils colorWithRed:41 green:176 blue:22]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:155 green:109 blue:64] endColor:[DKUtils colorWithRed:114 green:78 blue:42]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:199 green:214 blue:97] endColor:[DKUtils colorWithRed:158 green:171 blue:73]],
                [YMGradientColor colorWithStartColor:[DKUtils colorWithRed:214 green:76 blue:89] endColor:[DKUtils colorWithRed:167 green:55 blue:66]],
        ];
    });
    return colors;
}

+ (NSUInteger)capacityOfInt:(NSInteger)number {
    NSUInteger i = 0;
    while (number > 0) {
        number = number / 10;
        ++i;
    }
    return i;
}

+ (CGPoint)calculateGridForMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
    CGFloat delta = maxValue - minValue;
    CGFloat step = delta / 3;
    if (step > 1) {
        NSUInteger capacity = [YMUtils capacityOfInt:(NSInteger) step];
        double m = pow(10, capacity - 1);
        step = (CGFloat) m * roundf((float) (step / m));
        capacity = [YMUtils capacityOfInt:(NSInteger) step];
        m = pow(10, capacity - 1);
        CGFloat start = (minValue - step);
        start = (CGFloat) m * roundf((float) (start / m));
        start = (start > 0) ? start : 0;
        return CGPointMake(start, step);
    } else {
        CGFloat start = minValue - step;
        start = start > 0 ? start :0;
        return CGPointMake(start , step);
    }

}

+ (NSString *)textForNumber:(CGFloat)number {
    if (number < 10 && roundf(number) != number) {
        return [NSString stringWithFormat:@"%0.2f", number];
    }
    NSUInteger intNumber = (NSUInteger) number;
    if (intNumber < 1000)
        return [NSString stringWithFormat:@"%i", intNumber];
    else if (intNumber < 100000) {
        NSInteger div = intNumber / 1000;
        NSInteger mod = (intNumber % 1000) / 100;
        return [self formatWithDiv:div mod:mod symbol:@"k"];
    } else if (intNumber < 100000000) {
        NSInteger div = intNumber / 1000000;
        NSInteger mod = (intNumber % 1000000) / 100000;
        return [self formatWithDiv:div mod:mod symbol:@"m"];
    } else
        return @"∞";
}

+ (NSString *)formatWithDiv:(NSInteger)div mod:(NSInteger)mod symbol:(NSString *)symbol {
    if (mod == 0 || div >= 10)
        return [[NSString alloc] initWithFormat:@"%i%@", div, symbol];
    else
        return [[NSString alloc] initWithFormat:@"%i,%i%@", div, mod, symbol];
}


+ (void)hideKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end