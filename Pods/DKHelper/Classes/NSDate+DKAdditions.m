//
// Created by Dmitry Korotchenkov on 25.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+DKAdditions.h"

static NSString *const kCalendarKey = @"UTCCalendar";

@implementation NSDate (DKAdditions)

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat {
    return [self stringWithFormat:dateFormat inTimeZone:[NSTimeZone defaultTimeZone]];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat inTimeZone:(NSTimeZone *)timeZone {
    return [self stringWithFormat:dateFormat locale:nil inTimeZone:timeZone];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat locale:(NSLocale *)locale inTimeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timeZone) {
        [formatter setTimeZone:timeZone];
    }
    if (locale) {
        [formatter setLocale:locale];
    }
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:self];
}

- (NSUInteger)daysInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

+ (NSDate *)endOfYear:(NSInteger)year {
    NSDateComponents *components = [[NSDate new] components];
    components.year = year;
    [components setHour:23];
    [components setMinute:59];
    components.day = 31;
    components.month = 12;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)beginOfYear:(NSInteger)year {
    NSDateComponents *components = [[NSDate new] components];
    components.year = year;
    components.day = 1;
    components.month = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSInteger)currentYear {
    NSDateComponents *dateComponents = [[NSDate date] components];
    return dateComponents.year;
}

+ (NSInteger)currentMonth {
    NSDateComponents *components = [[NSDate date] components];
    return components.month;
}

- (NSDate *)beginOfDay {
    NSDateComponents *components = [self components];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfDay {
    NSDateComponents *components = [self components];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)beginOfMonth {
    NSDateComponents *components = [self components];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    NSDateComponents *components = [self components];
    components.month = components.month + 1;
    [components setDay:1];
    [components setHour:0];
    [components setMinute:-1];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (BOOL)isSameDay:(NSDate *)date {
    return ([self.beginOfDay compare:date.beginOfDay] == NSOrderedSame);
}

- (BOOL)isLessThan:(NSDate *)date {
    return ([self.beginOfDay compare:date.beginOfDay] == NSOrderedAscending);
}

- (BOOL)isMoreThan:(NSDate *)date {
    return ([self.beginOfDay compare:date.beginOfDay] == NSOrderedDescending);
}

- (BOOL)isLessThanOrEqual:(NSDate *)date {
    return ([self.beginOfDay compare:date.beginOfDay] == NSOrderedAscending) || ([self isSameDay:date]);
}

- (BOOL)isMoreThanOrEqual:(NSDate *)date {
    return ([self.beginOfDay compare:date.beginOfDay] == NSOrderedDescending) || ([self isSameDay:date]);
}

+ (NSDate *)makeDate:(NSInteger)day :(NSInteger)month :(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    return [calendar dateFromComponents:comps];
}

+ (NSDate *)today {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateInUTC {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                               fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

+ (NSTimeInterval)secondsSinceNow:(NSDate *)date {
    return [[NSDate dateInUTC] timeIntervalSinceDate:date];
}

- (NSDate *)dateByAddingDays:(NSInteger)number {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = number;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)number {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:number];
    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSString *)toStringWithFormat:(NSString *)format {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [NSCalendar currentCalendar];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)monthNameGenitive {
    return [self toStringWithFormat:@"MMMM"];
}

- (NSString *)monthNameNominative {
    return [self toStringWithFormat:@"LLLL"];
}

- (NSString *)monthNameNominativeWithYear {
    return [self toStringWithFormat:@"LLLL YYYY"];
}

- (NSDate *)mondayForCurrentWeek {
    return [self nthWeekDay:2];
}

- (NSDate *)sundayForCurrentWeek {
    return [self nthWeekDay:1];
}

- (NSDate *)nthWeekDay:(NSInteger)weekDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit
                                          fromDate:self];
    [comps setWeekday:weekDay];
    return [calendar dateFromComponents:comps];
}

- (NSInteger)daysToDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                               fromDate:self
                                                 toDate:date
                                                options:0];
    return components.day;
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger comp = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:comp fromDate:self];
}

- (NSInteger)second {
    return [self components].second;
}

- (NSInteger)minute {
    return [self components].minute;
}

- (NSInteger)hour {
    return [self components].hour;
}

- (NSInteger)day {
    return [self components].day;
}

- (NSInteger)month {
    return [self components].month;
}

- (NSInteger)year {
    return [self components].year;
}

- (NSInteger)weekDay {
    return [self components].weekday;
}

+ (NSDate *)min:(NSDate *)first :(NSDate *)second {
    NSComparisonResult result = [first compare:second];
    return (result == NSOrderedDescending) ? second : first;
}

+ (NSDate *)max:(NSDate *)first :(NSDate *)second {
    NSComparisonResult result = [first compare:second];
    return (result == NSOrderedDescending) ? first : second;
}

- (NSString *)formattedMinute {
    return [self formattedDate:@"mm"];
}

- (NSString *)formattedHour {
    return [self formattedDate:@"k"];
}

- (NSString *)formattedDate:(NSString *)format {
    return [self toStringWithFormat:format];
}

@end