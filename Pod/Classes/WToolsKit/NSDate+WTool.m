//
//  NSDate+WTool.m
//
//
//  Created by Linjw on 13-11-26.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "NSDate+WTool.h"
#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)
@implementation NSDate (WTool)

-(NSString *)debugDescription
{
    return [self wStringWithFormatStr:[NSString stringWithFormat:@"%@.sss",DefaultTimeStyle]];
}

-(NSUInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dayComponents year];
}

-(NSUInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dayComponents month];
}

-(NSUInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dayComponents day];
}
-(NSUInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (NSUInteger)hour;
}
-(NSUInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (NSUInteger)minute;
}
-(NSUInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components second];
    return (NSUInteger)minute;
}

-(WDayOfWeekType)weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    return (WDayOfWeekType)[weekdayComponents weekday];
}

-(NSString *)weekdayStr
{
    NSUInteger weekday = [self weekday];
    NSString * str = @"未知";
    switch (weekday) {
        case WDayOfWeekSun:
            str = @"周日";
            break;
        case WDayOfWeekMon:
            str = @"周一";
            break;
        case WDayOfWeekTue:
            str = @"周二";
            break;
        case WDayOfWeekWed:
            str = @"周三";
            break;
        case WDayOfWeekThu:
            str = @"周四";
            break;
        case WDayOfWeekFri:
            str = @"周五";
            break;
        case WDayOfWeekSat:
            str = @"周六";
            break;
        default:
            break;
    }
    return str;
}

-(BOOL)isLeapYear
{
    NSInteger year = [self year];
    return ((year%4 == 0 && year%100 != 0) || year%400 == 0);
}

+(id)wDateWithYear:(NSInteger)year
             Month:(NSInteger)month
               Day:(NSInteger)day
              Hour:(NSInteger)hour
            Minute:(NSInteger)minute
            Second:(NSInteger)second
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate * date = [calendar dateFromComponents:components];
#if !__has_feature(objc_arc)
    [components release];
#endif
    return date;
}

#pragma mark - 格式化

- (NSString *)wStringWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    NSString * str = nil;
    if (!dateFormatter) {
        NSDateFormatter * dateFormatterDefault = [[NSDateFormatter alloc]init];
        [dateFormatterDefault setDateFormat:DefaultTimeStyle];
        str = [dateFormatterDefault stringFromDate:self];
#if !__has_feature(objc_arc)//如果是MRC
        [dateFormatterDefault release];
#endif
    }else{
        str = [dateFormatter stringFromDate:self];
    }
    return str;
}

- (NSString *)wStringWithStrFormatter:(NSString *)strFormatter{
    NSString * str = nil;
    if (!strFormatter) {
        strFormatter = DefaultTimeStyle;
    }
    NSDateFormatter * dateFormatterDefault = [[NSDateFormatter alloc]init];
    [dateFormatterDefault setDateFormat:strFormatter];
    str = [dateFormatterDefault stringFromDate:self];
#if !__has_feature(objc_arc)//如果是MRC
    [dateFormatterDefault release];
#endif
    return str;
}

+ (NSDate *)wDateWithString:(NSString *)dateStr DateFormatter:(NSDateFormatter *)dateFormatter{
    NSDate * date = nil;
    if (!dateStr || !dateStr.length) {
        return nil;
    }
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:DefaultTimeStyle];
    }
    date = [dateFormatter dateFromString:dateStr];
#if !__has_feature(objc_arc)//如果是MRC
    [dateFormatter release];
#endif
    return date;
}

+ (NSDate *)wDateWithString:(NSString *)dateStr StrFormatter:(NSString *)strFormatter{
    NSDate * date = nil;
    if (!dateStr || !dateStr.length) {
        return nil;
    }
    
    if (!strFormatter.length ||!strFormatter) {
        strFormatter = DefaultTimeStyle;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:strFormatter];
    date = [[self class] wDateWithString:dateStr DateFormatter:dateFormatter];
#if !__has_feature(objc_arc)//如果是MRC
    [dateFormatter release];
#endif
    return date;
}

//生成时间
+ (NSDate *)wDateWithNum:(NSNumber *)dateNum
{
    long long int dtServer = [dateNum longLongValue];
    long long int dtLocal = dtServer;
    
    if(dtServer > 9999999999)
    {
        dtLocal = dtServer;
        while (dtLocal > 9999999999)
        {
            dtLocal = dtLocal/10;
        }
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:dtLocal];
    return date;
}

#pragma mark -
+ (NSDate *) wDateWithSince1970TimeMS:(long long int)timeMSForSince1970{
    return [NSDate dateWithTimeIntervalSince1970:timeMSForSince1970/1000];
}

/*
 -(NSDate *) wDateBeginning {
 //    long long int dtBegin = 0;
 NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
 [dateForma setDateFormat:@"yyyy-MM-dd"];
 NSString * strDate = [dateForma stringFromDate:self];
 NSString * strDtBegin = [NSString stringWithFormat:@"%@ 00:00:00",strDate];
 [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate * dateBegin = [dateForma dateFromString:strDtBegin];
 return dateBegin;
 }
 */

//得到一天的开始时间值,如@"2012-6-10 00:00:00"，这一天的0点就是开始时间
- (long long int) wBeginDateTimeMs{
    long long int dtBegin = 0;
    NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateForma stringFromDate:self];
    NSString * strDtBegin = [NSString stringWithFormat:@"%@ 00:00:00",strDate];
    [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateBegin = [dateForma dateFromString:strDtBegin];
    dtBegin = [dateBegin timeIntervalSince1970] * 1000;
#if !__has_feature(objc_arc)//如果是MRC
    [dateForma release];
#endif
    return dtBegin;
}

-(NSTimeInterval)wBeginDateTimeInterval {
    NSTimeInterval dtBegin = 0;
    NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateForma stringFromDate:self];
    NSString * strDtBegin = [NSString stringWithFormat:@"%@ 00:00:00",strDate];
    [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateBegin = [dateForma dateFromString:strDtBegin];
    dtBegin = [dateBegin timeIntervalSince1970];
    return dtBegin;
}

+(long long int)wBeginDateTimeMsWithDate:(NSDate *)date
{
    long long int dtBegin = 0;
    NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateForma stringFromDate:date];
    NSString * strDtBegin = [NSString stringWithFormat:@"%@ 00:00:00",strDate];
    [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateBegin = [dateForma dateFromString:strDtBegin];
    dtBegin = [dateBegin timeIntervalSince1970] * 1000;
#if !__has_feature(objc_arc)//如果是MRC
    [dateForma release];
#endif
    return dtBegin;
}

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
- (long long int) wEndDateTimeMs{
    long long int dtEnd = 0;
    
    //    dtEnd = [[self class] wGetEndDateTimeMsWithdtBeginMS:[[self class] wGetBeginDateTimeMsWithNSDate:date]];
    
    NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateForma stringFromDate:self];
    NSString * strDtEnd = [NSString stringWithFormat:@"%@ 23:59:59",strDate];
    [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateEnd = [dateForma dateFromString:strDtEnd];
    dtEnd = [dateEnd timeIntervalSince1970] * 1000;
#if !__has_feature(objc_arc)//如果是MRC
    [dateForma release];
#endif
    return dtEnd;
}
+(long long int)wEndDateTimeMsWithDate:(NSDate *)date
{
    long long int dtEnd = 0;
    
    //    dtEnd = [[self class] wGetEndDateTimeMsWithdtBeginMS:[[self class] wGetBeginDateTimeMsWithNSDate:date]];
    
    NSDateFormatter * dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateForma stringFromDate:date];
    NSString * strDtEnd = [NSString stringWithFormat:@"%@ 23:59:59",strDate];
    [dateForma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateEnd = [dateForma dateFromString:strDtEnd];
    dtEnd = [dateEnd timeIntervalSince1970] * 1000;
#if !__has_feature(objc_arc)//如果是MRC
    [dateForma release];
#endif
    return dtEnd;
}

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
+(long long int)wEndDateTimeMsWithDtBeginMS:(long long int)dtBeginMS
{
    return dtBeginMS + 86400000 - 1000;
}

//判断date是否是今天
- (BOOL) wIsDateToday{
    BOOL isToday = NO;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate * today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate * otherDate = [cal dateFromComponents:components];
    isToday = [today isEqualToDate:otherDate] ? YES : NO;
    return isToday;
}
//是否是昨天
-(BOOL)wIsYesterday
{
    return  [self wIsEqualToDateIgnoringTime:[NSDate wDateYesterday]];
}
//是否明天
-(BOOL)wIsTomorrow
{
    return  [self wIsEqualToDateIgnoringTime:[NSDate wDateTomorrow]];
}

+ (NSDate *)wDateTomorrow {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_DAY * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)wDateYesterday {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_DAY * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

//忽略时间判断日期是否相等
- (BOOL)wIsEqualToDateIgnoringTime:(NSDate *) otherDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components1 = [currentCalendar components:unitFlags fromDate:self];
    NSDateComponents *components2 = [currentCalendar components:unitFlags fromDate:otherDate];
    return (components1.year == components2.year) &&
    (components1.month == components2.month) &&
    (components1.day == components2.day);
}

+(BOOL)wIsDateTodayWithDate:(NSDate *)date
{
    BOOL isToday = NO;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate * today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate * otherDate = [cal dateFromComponents:components];
    isToday = [today isEqualToDate:otherDate] ? YES : NO;
    return isToday;
}

#pragma mark -

-(NSDate *)wDateEndOfDay {
    long long int timeLong = [self wEndDateTimeMs];
    return [NSDate dateWithTimeIntervalSince1970:timeLong/1000];
}

//该月的最后一天
- (NSDate *)wDateEndOfMonth
{
    return [[[[self wDateBeginningOfMonth] wDateAfterMonth:1] wDateAfterDay:-1] wDateEndOfDay];
}

//返回当前周的周末
- (NSDate *)wDateEndOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    // to get the end of week for a particular date, add (7 - weekday) days
    
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif
    return [endOfWeek wDateEndOfDay];
}

//该日期是该年的第几周
- (int )wIndexWeekOfYear
{
    int i;
    NSUInteger year = [self year];
    NSDate * date = [self wDateEndOfWeek];
    for (i = 1;[[date wDateAfterDay:-7 * i] year] == year;i++)
    {
        
    }
    return i;
}

//在当前日期前几天
- (NSUInteger)wDaysAgoFromCurrentDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

//与某个日期相差几天
- (NSInteger)wDaysAgoFromDate:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:aDate
                                                options:0];
    return [components day];
    
}

//与某个日期相差几秒钟
- (long long)wSecondsAfterFromDate:(NSDate *)aDate
{
    long long second = [self timeIntervalSinceDate:aDate];
    return second;
}

//是否是在date1与date2之间
-(BOOL)wIsBetweenDate1:(NSDate *)date1 Date2:(NSDate *)date2
{
    NSTimeInterval val1 = [date1 timeIntervalSince1970];
    NSTimeInterval val2 = [date2 timeIntervalSince1970];
    NSTimeInterval max = val2>=val1 ? val2 : val1;
    NSTimeInterval min = val2<=val1 ? val2 : val1;
    NSTimeInterval val = [self timeIntervalSince1970];
    return (val>=min && val<=max)?YES:NO;
}

//返回当前月一共有几周(可能为4,5,6)
- (NSUInteger)wCountForWeekOfMonth
{
    return [[self wDateEndOfMonth] wIndexWeekOfYear] - [[self wDateBeginningOfMonth] wIndexWeekOfYear] + 1;
}
//当月总共多少天(可能为28,29,30,31)
-(NSUInteger)wCountForDayOfMonth
{
    NSInteger nthMonth = [self month];
    NSInteger days[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if ([self isLeapYear]) {
        return nthMonth == 2 ? 29 : 28;
    }
    return days[nthMonth - 1];
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)wDateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif
    return dateAfterDay;
}
//month个月后的日期
- (NSDate *)wDateAfterMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif
    return dateAfterMonth;
}

//返回当前天的年月日.
- (NSDate *)wDateBeginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}
//返回周日的的开始时间
- (NSDate *)wDateBeginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    
    // we'll use the default calendar and hope for the best
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
    
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    
    if (ok) {
        return beginningOfWeek;
    }
    
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    
#if ! __has_feature(objc_arc)
    [componentsToSubtract release];
#endif
    return [calendar dateFromComponents:components];
}



//返回该月的第一天
- (NSDate *)wDateBeginningOfMonth
{
    return [[self wDateAfterDay:-(int)[self day] + 1] wDateBeginningOfDay];
}

//午夜时间距今几天
- (NSUInteger)wDaysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
#if ! __has_feature(objc_arc)
    [mdf release];
#endif
    return (NSUInteger)([midnight timeIntervalSinceNow] / (60*60*24) * -1);
}


- (NSString *)wStringWithFormatStr:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [outputFormatter release];
#endif
    return timestamp_str;
}

//某年某月有多少天
+(NSUInteger)wCountForDayOfMonth:(NSInteger)month
                          OfYear:(NSInteger)year
{
    NSDate * date = [self wDateWithYear:year Month:month Day:0 Hour:0 Minute:0 Second:0];
    return [date wCountForDayOfMonth];;
}

- (NSString *)wStringWithDateStyle:(NSDateFormatterStyle)dateStyle TimeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
#if !__has_feature(objc_arc)
    [outputFormatter release];
#endif
    return outputString;
}




@end



















