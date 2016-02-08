//
// Created by Dmitry Korotchenkov on 26.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAppDelegate.h"

@class YMGradientColor;

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_7                  SYSTEM_VERSION_LESS_THAN(@"7")
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#define APPDELEGATE                                 ((YMAppDelegate *) [UIApplication sharedApplication].delegate)
#define STORYBOARD                                  APPDELEGATE.window.rootViewController.storyboard

typedef struct YMInterval YMInterval;

struct YMInterval {
    CGFloat intervalStart;
    CGFloat intervalEnd;
};

YMInterval YMIntervalMake(float start, float end);

NSComparisonResult floatCompare(float value1, float value2);

static NSString *kRussianLang = @"ru";
static NSString *kEnglishLang = @"en";

@interface YMUtils : NSObject

+ (BOOL)isPreferredRussianLanguage;

+ (NSString *)createAccountName;

+ (YMGradientColor *)createCounterColorWithAlreadyExistingCounters:(NSSet *)counters;

+ (NSInteger)daysFrom:(NSDate *)date1 to:(NSDate *)date2;

+ (NSInteger)daysBetween:(NSDate *)date1 :(NSDate *)date2;

+ (NSArray *)counterColors;

+ (NSUInteger)capacityOfInt:(NSInteger)number;

// start - x; step - y
+ (CGPoint)calculateGridForMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

+ (NSString *)textForNumber:(CGFloat)number;

+ (void)hideKeyboard;
@end