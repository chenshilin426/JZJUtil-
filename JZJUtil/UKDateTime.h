//
//  UKDateTime.h
//  UKMedia
//
//  Created by wlmt-yujiao on 2017/8/11.
//  Copyright © 2017年 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UKDateTime : NSObject
{
}

//一个时间戳距离当前时间日分秒，常用于 10秒前，10分钟前，10小时前。。。。
+(NSString *)twoTimestampSub:(NSString *)oneTime nowTime:(NSString *)nowTime;



/**
 *  时间转时间，2020-01-01 00:00:00 - 2020-01-01
 */
+ (NSString *)UKTime:(NSString *)notime outTimeStatus:(NSString *)status;


/**
 *  与当前时间比较 （n分钟前、n小时前、n日前。。。。）
 */
+ (NSString *)UKDatenoTime:(NSString *)notime offTime:(NSString *)offtime;
/**
 * 时间搓转换时间 （strTime：时间搓  status：返回时间格式）
 */
+ (NSString *)UKDateTimeStamp:(NSString *)strTime andTimeStatus:(NSString *)status;
/**
 * 时间搓转换时间 （strTime：时间  status：返回时间格式）
*/
+ (NSString *)UKDateTime:(NSString *)strDate andTimeStatus:(NSString *)status;
/**
 * 获取当前时间 （status：返回时间格式）
 */
+ (NSString *)UKToTimeStatus:(NSString *)status;
/**
 * 获取昨天
*/
+ (NSString *)UKUp_ToTimeStatus:(NSString *)status;
/**
 *  计算  距离现在的时间   (今天、昨天。。。)
 */
+ (NSString *)UKDatecompareDate:(NSString *)notime;
/**
 *  两个时间做比较
 */
+ (NSString *)ukdatetimeonline:(NSString *)online;
/**
 *  时间转时间戳
 */
+(NSInteger)ukTimeSwitchTimestamp:(NSString *)formatTime;
/**
 *  获取当前时间戳 (以毫秒为单位）
 */
+ (NSInteger)ukGetNowTimeTimesta;
/**
 * 获取系统是24小时制还是12小时制
 */
+ (BOOL)ukHasAMPM;
/**
 * 两个时间相差多少天多少小时多少分多少秒
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 * 一个时间段与当前时间做比较
 * scope： 几天内显示将要开始/结束
 * startTime_c / endTime_c
 */
+ (NSString *)ukScope:(NSInteger)scopeNum enterTime:(NSString *)enterTime_c endTime:(NSString *)endTime_c;

/**
 * 根据时间返回农历日期
 */
+ (NSString *)getChineseCalendarWithDate:(NSString *)date;

/**
 * 根据时间返回星期几
 */
+ (NSString*)weekdayStringFromDate:(NSString *)string;

/**
 * 获取当前日期是星期几
 */
+ (NSString *)ukGetWeekDayFordates;

/**
 * 获取是否位晚上 YES ：晚上
 */
+ (BOOL)ukGetNight;


/**
 获取最近八天时间 数组
 */
+ (NSArray *)latelyEightTime;

@end
