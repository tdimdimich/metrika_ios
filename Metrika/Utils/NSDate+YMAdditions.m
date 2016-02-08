//
// Created by Dmitry Korotchenkov on 26.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+YMAdditions.h"

static NSString *const kCalendarKey = @"UTCCalendar";

@implementation NSDate (YMAdditions)

// return new date in UTC from "ddMMyyyy" format
+(NSDate *)dateInUTCFromString:(NSString *)ddMMyyyy {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy"];
    [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
    return [formatter dateFromString:ddMMyyyy];
}

// return new string in "yyyyMMdd" format from date
-(NSString *)stringInddMMyyyyFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:self];
}








+ (NSDate *)endOfYear:(NSInteger)year {
    NSDateComponents *components = [[NSDate new] components];
    components.year = year;
    [components setHour:23];
    [components setMinute:59];
    components.day = 31;
    components.month = 12;
    return [[NSDate UTCCalendar] dateFromComponents:components];
}

+ (NSDate *)beginOfYear:(NSInteger)year {
    NSDateComponents *components = [[NSDate new] components];
    components.year = year;
    components.day = 1;
    components.month = 1;
    return [[NSDate UTCCalendar] dateFromComponents:components];
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
    return [[NSDate UTCCalendar] dateFromComponents:components];
}

- (NSDate *)endOfDay {
    NSDateComponents *components = [self components];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSDate UTCCalendar] dateFromComponents:components];
}

- (NSDate *)beginOfMonth {
    NSDateComponents *components = [self components];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSDate UTCCalendar] dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    NSDateComponents *components = [self components];
    components.month = components.month + 1;
    [components setDay:1];
    [components setHour:0];
    [components setMinute:-1];
    return [[NSDate UTCCalendar] dateFromComponents:components];
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

+ (NSCalendar *)UTCCalendar {
    NSMutableDictionary *threadLocal = [NSThread currentThread].threadDictionary;
    NSCalendar *calendar = [threadLocal objectForKey:kCalendarKey];
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [calendar setTimeZone:[self UTCTimeZone]];
        [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        [threadLocal setObject:calendar forKey:kCalendarKey];
    }
    return calendar;
}

+ (NSTimeZone *)UTCTimeZone {
    static NSTimeZone *timeZone = nil;
    if (!timeZone) {
        timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    return timeZone;
}

+ (NSDate *)makeDate:(NSInteger)day :(NSInteger)month :(NSInteger)year {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    return [calendar dateFromComponents:comps];
}

+ (NSDate *)today {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateInUTC {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                               fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

+ (NSTimeInterval)secondsSinceNow:(NSDate *)date {
    return [[NSDate dateInUTC] timeIntervalSinceDate:date];
}

- (NSDate *)dateByAddingDays:(NSInteger)number {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = number;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)number {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:number];
    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSString *)toStringWithFormat:(NSString *)format {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = [NSDate UTCCalendar];
        dateFormatter.timeZone = [NSDate UTCTimeZone];
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
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *comps = [calendar components:NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit
                                          fromDate:self];
    [comps setWeekday:weekDay];
    return [calendar dateFromComponents:comps];
}

- (NSInteger)daysToDate:(NSDate *)date {
    NSCalendar *calendar = [NSDate UTCCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                               fromDate:self
                                                 toDate:date
                                                options:0];
    return components.day;
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSDate UTCCalendar];
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