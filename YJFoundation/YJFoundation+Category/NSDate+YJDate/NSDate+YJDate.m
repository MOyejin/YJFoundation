//
//  NSDate+YJDate.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSDate+YJDate.h"

@implementation NSDate (YJDate)

- (NSInteger)yj_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)yj_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)yj_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)yj_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)yj_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)yj_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)yj_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)yj_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)yj_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)yj_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)yj_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yj_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)yj_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)yj_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)yj_isLeapYear {
    NSUInteger year = self.yj_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)yj_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].yj_day == self.yj_day;
}

- (BOOL)yj_isYesterday {
    NSDate *added = [NSDate yj_getDaysDateWithDate:self
                                              days:1];
    return [added yj_isToday];
}

#pragma mark - 时间戳处理/计算日期
+ (NSString *)yj_compareCureentTimeWithDate:(NSTimeInterval)timeStamp {
    
    NSDate *yj_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSTimeInterval yj_timeInterval = [yj_timeDate timeIntervalSinceNow];
    
    yj_timeInterval = -yj_timeInterval;
    
    NSInteger temp = 0;
    
    NSCalendar *yj_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger yj_unitFlags  = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *yj_dateComponents = [yj_calendar components:yj_unitFlags
                                                         fromDate:yj_timeDate];
    
    if (yj_timeInterval < 60) {
        
        return [NSString stringWithFormat:@"刚刚"];
        
    } else if((temp = yj_timeInterval / 60) < 60){
        
        return [NSString stringWithFormat:@"%ld分钟前", (long)temp];
        
    } else if((temp = yj_timeInterval / 3600) < 24){
        
        return [NSString stringWithFormat:@"%ld小时前", (long)temp];
        
    } else if ((temp = yj_timeInterval / 3600 / 24) == 1) {
        
        return [NSString stringWithFormat:@"昨天%ld时", (long)yj_dateComponents.hour];
        
    } else if ((temp = yj_timeInterval / 3600 / 24) == 2) {
        
        return [NSString stringWithFormat:@"前天%ld时", (long)yj_dateComponents.hour];
        
    } else if((temp = yj_timeInterval / 3600 / 24) < 31){
        
        return [NSString stringWithFormat:@"%ld天前", (long)temp];
        
    } else if((temp = yj_timeInterval / 3600 / 24 / 30) < 12){
        
        return [NSString stringWithFormat:@"%ld个月前",(long)temp];
        
    } else {
        
        return [NSString stringWithFormat:@"%ld年前", (long)temp / 12];
    }
}

+ (NSString *)yj_getCurrentTimeStampString {
    
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSTimeInterval)yj_getCurrentTimeStamp {
    
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)yj_displayTimeWithTimeStamp:(NSTimeInterval)timeStamp {
    
    NSDate *yj_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSCalendar *yj_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger yj_unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *yj_dateComponents = [yj_calendar components:yj_unitFlags
                                                         fromDate:yj_timeDate];
    
    NSInteger yj_year   = yj_dateComponents.year;
    NSInteger yj_month  = yj_dateComponents.month;
    NSInteger yj_day    = yj_dateComponents.day;
    NSInteger yj_hour   = yj_dateComponents.hour;
    NSInteger yj_minute = yj_dateComponents.minute;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld:%ld", (long)yj_year, (long)yj_month, (long)yj_day, (long)yj_hour, (long)yj_minute];
}

+ (NSString *)yj_calculateDaysWithDate:(NSDate *)date {
    
    NSDate *yj_currentDate = [NSDate date];
    
    NSCalendar *yj_calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *comps_today = [yj_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:yj_currentDate];
    NSDateComponents *comps_other = [yj_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:date];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        
        return @"今天";
        
    } else if (comps_today.year == comps_other.year &&
               comps_today.month == comps_other.month &&
               (comps_today.day - comps_other.day) == -1 ) {
        
        return @"明天";
        
    } else if (comps_today.year == comps_other.year &&
               comps_today.month == comps_other.month &&
               (comps_today.day - comps_other.day) == -2) {
        
        return @"后天";
        
    }else if (comps_today.year == comps_other.year &&
              (comps_today.month - comps_other.month) == -1 &&
              comps_other.day == 1){
        
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              (comps_today.month - comps_other.month) == -1 &&
              comps_other.day == 2){
        
        return @"后天";
        
    }else if ((comps_today.year - comps_other.year) == - 1 &&
              comps_other.month == 1){
        
        return @"明天";
        
    }else if ((comps_today.year - comps_other.year) == - 1 &&
              comps_other.month == 2){
        
        return @"后天";
        
    }
    
    return @"";
}

#pragma mark - 获取日期
+ (NSUInteger)yj_getEraWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitEra
                                                                       date:date];
    
    return yj_dateComponents.era;
}

+ (NSUInteger)yj_getYearWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitYear
                                                                       date:date];
    
    return yj_dateComponents.year;
}

+ (NSUInteger)yj_getMonthWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitMonth
                                                                       date:date];
    
    return yj_dateComponents.month;
}

+ (NSUInteger)yj_getDayWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitDay
                                                                       date:date];
    
    return yj_dateComponents.day;
}

+ (NSUInteger)yj_getHourWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitHour
                                                                       date:date];
    
    return yj_dateComponents.hour;
}

+ (NSUInteger)yj_getMinuteWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitMinute
                                                                       date:date];
    
    return yj_dateComponents.minute;
}

+ (NSUInteger)yj_getSecondWithDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitSecond
                                                                       date:date];
    
    return yj_dateComponents.second;
}

+ (NSInteger)yj_getWeekdayStringFromDate:(NSDate *)date {
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:NSCalendarUnitWeekday
                                                                       date:date];
    
    return yj_dateComponents.weekday;
}

+ (NSInteger)yj_getDateTimeDifferenceWithBeginDate:(NSDate *)beginDate
                                           endDate:(NSDate *)endDate {
    
    NSCalendar *yj_calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *yj_dateComponents = [yj_calendar components:NSCalendarUnitDay
                                                         fromDate:beginDate
                                                           toDate:endDate
                                                          options:0];
    
    return yj_dateComponents.day;
}

+ (NSDate *)yj_getMonthFirstDeteWithDate:(NSDate *)date {
    
    return [self yj_getDaysDateWithDate:date
                                   days:-[self yj_getDayWithDate:date] + 1];
}

+ (NSDate *)yj_getMonthLastDayWithDate:(NSDate *)date {
    
    NSDate *yj_firstDate = [self yj_getMonthFirstDeteWithDate:date];
    NSDate *yj_monthDate = [self yj_getMonthDateWithDate:yj_firstDate
                                                  months:1];
    return [self yj_getDaysDateWithDate:yj_monthDate
                                   days:-1];
}

+ (NSUInteger)yj_getWeekOfYearWithDate:(NSDate *)date {
    
    NSUInteger yj_week = 1;
    NSUInteger yj_year = [self yj_getYearWithDate:date];
    
    NSDate *yj_lastDate = [self yj_getMonthLastDayWithDate:date];
    
    while ([self yj_getYearWithDate:[self yj_getDaysDateWithDate:yj_lastDate
                                                            days:-7 * yj_week]] == yj_year) {
        yj_week++;
    };
    
    return yj_week;
}

+ (NSDate *)yj_getTomorrowDay:(NSDate *)date {
    
    NSCalendar *yj_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *yj_dateComponents = [yj_calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                         fromDate:date];
    
    yj_dateComponents.day = yj_dateComponents.day + 1;
    
    return [yj_calendar dateFromComponents:yj_dateComponents];
}

+ (NSDate *)yj_getYearDateWithDate:(NSDate *)date
                             years:(NSInteger)years {
    
    NSCalendar *yj_calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *yj_dateComponents = [[NSDateComponents alloc] init];
    
    yj_dateComponents.year = years;
    
    return [yj_calendar dateByAddingComponents:yj_dateComponents
                                        toDate:date
                                       options:0];
}

+ (NSDate *)yj_getMonthDateWithDate:(NSDate *)date
                             months:(NSInteger)months {
    
    
    NSDateComponents *yj_dateComponents = [[NSDateComponents alloc] init];
    
    yj_dateComponents.month = months;
    
    return [self yj_getDateWithDateComponents:yj_dateComponents
                                         date:date];
}

+ (NSDate *)yj_getDaysDateWithDate:(NSDate *)date
                              days:(NSInteger)days {
    
    NSDateComponents *yj_dateComponents = [[NSDateComponents alloc] init];
    
    yj_dateComponents.day = days;
    
    return [self yj_getDateWithDateComponents:yj_dateComponents
                                         date:date];
}

+ (NSDate *)yj_getHoursDateWithDate:(NSDate *)date
                              hours:(NSInteger)hours {
    
    NSDateComponents *yj_dateComponents = [[NSDateComponents alloc] init];
    
    yj_dateComponents.hour = hours;
    
    return [self yj_getDateWithDateComponents:yj_dateComponents
                                         date:date];
}

#pragma mark - 日期格式化
+ (NSString *)yj_getStringDateWithTimeStamp:(NSTimeInterval)timeStamp
                                  formatter:(NSString *)formatter {
    
    if ([NSString stringWithFormat:@"%@", @(timeStamp)].length == 13) {
        
        timeStamp /= 1000.0f;
    }
    
    NSDate *yj_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    yj_dateFormatter.dateFormat = formatter;
    
    return [yj_dateFormatter stringFromDate:yj_timeDate];
}

- (NSString *)yj_getStringDateWithFormatter:(NSString *)formatter {
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    yj_dateFormatter.dateFormat = formatter;
    yj_dateFormatter.locale     = [NSLocale currentLocale];
    
    return [yj_dateFormatter stringFromDate:self];
}

+ (NSString *)yj_getStringDateWithDate:(NSDate *)date
                             formatter:(NSString *)formatter {
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    yj_dateFormatter.dateFormat = formatter;
    
    return [yj_dateFormatter stringFromDate:date];
}

+ (NSString *)yj_getStringDateWithDate:(NSDate *)date
                             formatter:(NSString *)formatter
                              timeZone:(NSTimeZone *)timeZone
                                locale:(NSLocale *)locale {
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    [yj_dateFormatter setDateFormat:formatter];
    
    if (timeZone) {
        [yj_dateFormatter setTimeZone:timeZone];
    }
    
    if (locale) {
        [yj_dateFormatter setLocale:locale];
    }
    
    return [yj_dateFormatter stringFromDate:date];
}

+ (NSDate *)yj_getDateWithDateString:(NSString *)dateString
                           formatter:(NSString *)formatter {
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    [yj_dateFormatter setDateFormat:formatter];
    
    return [yj_dateFormatter dateFromString:dateString];
}

+ (NSDate *)yj_getDateWithDateString:(NSString *)dateString
                           formatter:(NSString *)formatter
                            timeZone:(NSTimeZone *)timeZone
                              locale:(NSLocale *)locale {
    
    NSDateFormatter *yj_dateFormatter = [[NSDateFormatter alloc] init];
    
    [yj_dateFormatter setDateFormat:formatter];
    
    if (timeZone) {
        
        [yj_dateFormatter setTimeZone:timeZone];
    }
    
    if (locale) {
        
        [yj_dateFormatter setLocale:locale];
    }
    
    return [yj_dateFormatter dateFromString:dateString];
}

#pragma mark - 日期判断
+ (BOOL)yj_isLeapYear:(NSDate *)date {
    
    NSUInteger yj_year = [self yj_getYearWithDate:date];
    
    return ((yj_year % 4 == 0) && (yj_year % 100 != 0)) || (yj_year % 400 == 0);
}

+ (BOOL)yj_checkTodayWithDate:(NSDate *)date {
    
    NSInteger yj_calendarUnit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *yj_dateComponents = [self yj_getCalendarWithUnitFlags:yj_calendarUnit
                                                                       date:date];
    
    NSDateComponents *yj_currentDateComponents = [self yj_getCalendarWithUnitFlags:yj_calendarUnit
                                                                              date:[NSDate date]];
    
    return (yj_currentDateComponents.year == yj_dateComponents.year) &&
    (yj_currentDateComponents.month == yj_dateComponents.month) &&
    (yj_currentDateComponents.day == yj_dateComponents.day);
}


#pragma mark - 获取NSDateComponents
+ (NSDateComponents *)yj_getCalendarWithUnitFlags:(NSCalendarUnit)unitFlags
                                             date:(NSDate *)date {
    
    NSCalendar *yj_calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    return [yj_calendar components:unitFlags
                          fromDate:date];
}

#pragma mark - 私有API
+ (NSDate *)yj_getDateWithDateComponents:(NSDateComponents *)dateComponents
                                    date:(NSDate *)date {
    
    NSCalendar *yj_calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    return [yj_calendar dateByAddingComponents:dateComponents
                                        toDate:date
                                       options:0];
}


@end
