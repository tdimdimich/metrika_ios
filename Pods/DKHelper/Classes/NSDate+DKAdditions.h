//
// Created by Dmitry Korotchenkov on 25.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDate (DKAdditions)

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;

- (NSString *)stringWithFormat:(NSString *)dateFormat;

- (NSString *)stringWithFormat:(NSString *)dateFormat inTimeZone:(NSTimeZone *)timeZone;

- (NSString *)stringWithFormat:(NSString *)dateFormat locale:(NSLocale *)locale inTimeZone:(NSTimeZone *)timeZone;

- (NSUInteger)daysInMonth;

+ (NSDate *)endOfYear:(NSInteger)year;

+ (NSDate *)beginOfYear:(NSInteger)year;

+ (NSInteger)currentYear;

+ (NSInteger)currentMonth;

- (NSDate *)beginOfDay;

- (NSDate *)endOfDay;

- (NSDate *)beginOfMonth;

- (NSDate *)endOfMonth;

- (BOOL)isSameDay:(NSDate *)date;

- (BOOL)isLessThan:(NSDate *)date;

- (BOOL)isMoreThan:(NSDate *)date;

- (BOOL)isLessThanOrEqual:(NSDate *)date;

- (BOOL)isMoreThanOrEqual:(NSDate *)date;

+ (NSDate *)makeDate:(NSInteger)day :(NSInteger)month :(NSInteger)year;

+ (NSDate *)today;

+ (NSDate *)dateInUTC;

+ (NSTimeInterval)secondsSinceNow:(NSDate *)date;

- (NSDate *)dateByAddingDays:(NSInteger)number;

- (NSDate *)dateByAddingMonths:(NSInteger)number;

- (NSString *)toStringWithFormat:(NSString *)format;

- (NSString *)monthNameGenitive;

- (NSString *)monthNameNominative;

- (NSString *)monthNameNominativeWithYear;

- (NSDate *)mondayForCurrentWeek;

- (NSDate *)sundayForCurrentWeek;

- (NSInteger)daysToDate:(NSDate *)date;

- (NSDateComponents *)components;

- (NSInteger)second;

- (NSInteger)minute;

- (NSInteger)hour;

- (NSInteger)day;

- (NSInteger)month;

- (NSInteger)year;

- (NSInteger)weekDay;

- (NSString *)formattedMinute;

- (NSString *)formattedHour;

+ (NSDate *)min:(NSDate *)first :(NSDate *)second;

+ (NSDate *)max:(NSDate *)first :(NSDate *)second;
@end