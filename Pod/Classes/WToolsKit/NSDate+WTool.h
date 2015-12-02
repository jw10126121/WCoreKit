//
//  NSDate+WTool.h
//
//
//  Created by ljw on 13-11-26.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultTimeStyle              @"yyyy-MM-dd HH:mm:ss"
#define TimeStyle_Date                @"yyyy-MM-dd"
#define TimeStyle_Date_NoSeparator    @"yyyyMMdd"
#define TimeStyle_Time                @"HH:mm:ss"

#define NumForSecondsPerMinute (60)
#define NumForSecondsPerHour   (3600)
#define NumForSecondsPerDay    (86400)
#define NumForSecondsPerWeek   (604800)


typedef NS_ENUM(NSInteger, WDayOfWeekType)
{
    WDayOfWeekUnknown = 0,
    WDayOfWeekSun,
    WDayOfWeekMon,
    WDayOfWeekTue,
    WDayOfWeekWed,
    WDayOfWeekThu,
    WDayOfWeekFri,
    WDayOfWeekSat
};

/**
 *  时间辅助类
 */
@interface NSDate (WTool)

@property(nonatomic,assign,readonly)NSUInteger year;
@property(nonatomic,assign,readonly)NSUInteger month;
@property(nonatomic,assign,readonly)NSUInteger day;
@property(nonatomic,assign,readonly)NSUInteger hour;
@property(nonatomic,assign,readonly)NSUInteger minute;
@property(nonatomic,assign,readonly)NSUInteger second;
@property(nonatomic,assign,readonly)WDayOfWeekType weekday;
@property(nonatomic, copy ,readonly)NSString * weekdayStr;//例:周一
@property(nonatomic,assign,readonly)BOOL isLeapYear;//是否是润年

#pragma mark  - NSDate 生成
/*!
 *  生成日期
 */
+(id)wDateWithYear:(NSInteger)year
             Month:(NSInteger)month
               Day:(NSInteger)day
              Hour:(NSInteger)hour
            Minute:(NSInteger)minute
            Second:(NSInteger)second;



#pragma mark - 格式化

//根据dateFormatter得到时间字符串
- (NSString *)wStringWithDateFormatter:(NSDateFormatter *)dateFormatter;

//根据strFormatter得到时间字符串
- (NSString *)wStringWithStrFormatter:(NSString *)strFormatter;

//根据字符串格式,返回时间的字符串
- (NSString *)wStringWithFormatStr:(NSString *)formatStr;

//根据日期和时间格式,返回时间字符串
- (NSString *)wStringWithDateStyle:(NSDateFormatterStyle)dateStyle TimeStyle:(NSDateFormatterStyle)timeStyle;

//生成时间
+ (NSDate *)wDateWithString:(NSString *)dateStr DateFormatter:(NSDateFormatter *)dateFormatter;

//生成时间
+ (NSDate *)wDateWithString:(NSString *)dateStr StrFormatter:(NSString *)strFormatter;

//生成时间
+ (NSDate *)wDateWithNum:(NSNumber *)dateNum;

#pragma mark -

//根据毫秒级时间戳得到时间
+ (NSDate *) wDateWithSince1970TimeMS:(long long int)timeMSForSince1970;

-(NSTimeInterval)wBeginDateTimeInterval;

//-(NSDate *) wDateBeginning;

//得到一天的开始时间值,如@"2012-6-10 00:00:00"，这一天的0点就是开始时间
- (long long int) wBeginDateTimeMs;
+ (long long int) wBeginDateTimeMsWithDate:(NSDate *)date;

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
- (long long int) wEndDateTimeMs;
+ (long long int) wEndDateTimeMsWithDate:(NSDate *)date;

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
+ (long long int) wEndDateTimeMsWithDtBeginMS:(long long int)dtBeginMS;

//判断date是否是今天
- (BOOL)wIsDateToday;
+ (BOOL)wIsDateTodayWithDate:(NSDate *)date;

//是否是昨天
-(BOOL)wIsYesterday;
//是否明天
-(BOOL)wIsTomorrow;
//明天这个时候
+ (NSDate *)wDateTomorrow;
//昨天这个时候
+ (NSDate *)wDateYesterday;

//忽略时间判断日期是否相等
- (BOOL)wIsEqualToDateIgnoringTime:(NSDate *) otherDate;

#pragma mark -

//当天的结束
-(NSDate *)wDateEndOfDay;

//该月的最后一天
- (NSDate *)wDateEndOfMonth;

//返回当前周的周末
- (NSDate *)wDateEndOfWeek;

//该日期是该年的第几周
- (int )wIndexWeekOfYear;

//在当前日期前几天
- (NSUInteger)wDaysAgoFromCurrentDate;

//与某个日期相差几天
- (NSInteger)wDaysAgoFromDate:(NSDate *)aDate;

//与某个日期相差几秒钟
- (long long)wSecondsAfterFromDate:(NSDate *)aDate;

//是否是在date1与date2之间
-(BOOL)wIsBetweenDate1:(NSDate *)date1 Date2:(NSDate *)date2;

//返回当前月一共有几周(可能为4,5,6)
- (NSUInteger)wCountForWeekOfMonth;

//当月总共多少天(可能为28,29,30,31)
-(NSUInteger)wCountForDayOfMonth;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)wDateAfterDay:(int)day;

//month个月后的日期
- (NSDate *)wDateAfterMonth:(int)month;

//返回当前天的开始时间.
- (NSDate *)wDateBeginningOfDay;

//返回周日的开始时间
- (NSDate *)wDateBeginningOfWeek;

//返回该月的开始时间
- (NSDate *)wDateBeginningOfMonth;

//午夜时间距今几天
- (NSUInteger)wDaysAgoAgainstMidnight;

//某年某月有多少天(可能为28,29,30,31)
+(NSUInteger)wCountForDayOfMonth:(NSInteger)month OfYear:(NSInteger)year;








@end












