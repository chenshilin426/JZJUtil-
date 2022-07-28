//
//  UKDateTime.m
//  UKMedia
//
//  Created by wlmt-yujiao on 2017/8/11.
//  Copyright © 2017年 Fan. All rights reserved.
//

#import "UKDateTime.h"

@implementation UKDateTime

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


//一个时间戳距离当前时间日分秒
+(NSString *)twoTimestampSub:(NSString *)oneTime nowTime:(NSString *)nowTime{
    // 1.确定时间
//    NSString *time1 = @"2015-06-23 12:18:15";
//    NSString *time2 = @"2015-06-28 10:10:10";
    
    
//    NSDate *date11 = [NSDate dateWithTimeIntervalSince1970:[oneTime doubleValue]];
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *time1 = [formatter1 stringFromDate: date11];
//
//
//    NSDate *date22 = [NSDate dateWithTimeIntervalSince1970:[nowTime doubleValue]];
//    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *time2 = [formatter2 stringFromDate: date22];
//
    
    
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:nowTime];
    NSDate *date2 = [formatter dateFromString:oneTime];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 5.输出结果
//    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    NSString * result = nil;
//    if (cmps.year && cmps.month && cmps.day && cmps.hour && cmps.minute && cmps.second) {
//        result = [NSString stringWithFormat:@"%ld年%ld月%ld日%ld小时%ld分钟%ld秒",cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second];
//    }else if (cmps.month && cmps.day && cmps.hour && cmps.minute && cmps.second){
//         result = [NSString stringWithFormat:@"%ld月%ld日%ld小时%ld分钟%ld秒", cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second];
//    }else if (cmps.day && cmps.hour && cmps.minute && cmps.second){
//        result = [NSString stringWithFormat:@"%ld日%ld小时%ld分钟%ld秒", cmps.day, cmps.hour, cmps.minute, cmps.second];
//    }else if (cmps.hour && cmps.minute && cmps.second){
//        result = [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒", cmps.hour, cmps.minute, cmps.second];
//    }else if (cmps.minute && cmps.second){
//        result = [NSString stringWithFormat:@"%ld分钟%ld秒", cmps.minute, cmps.second];
//    }else if (cmps.second){
//        result = [NSString stringWithFormat:@"%ld秒", cmps.second];
//    }else{
//        result = @"0秒";
//    }
    if (cmps.year) {
        result = [NSString stringWithFormat:@"剩余%ld年",(long)cmps.year];
    }else if (cmps.month){
        result = [NSString stringWithFormat:@"剩余%ld月", (long)cmps.month];
    }else if (cmps.day){
        result = [NSString stringWithFormat:@"剩余%ld天%ld:%ld", (long)cmps.day, (long)cmps.hour, (long)cmps.minute];
    }else if (cmps.hour){
        result = [NSString stringWithFormat:@"剩余%ld:%ld", (long)cmps.hour, (long)cmps.minute];
    }else if (cmps.minute){
        result = [NSString stringWithFormat:@"剩余00:%ld", (long)cmps.minute];
    }else if (cmps.second){
        result = [NSString stringWithFormat:@"剩余%ld秒", (long)cmps.second];
    }else{
        result = @"剩余0秒";
    }
    return result;
}



+ (NSString *)UKTime:(NSString *)notime outTimeStatus:(NSString *)status {
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[UKDateTime ukTimeSwitchTimestamp:notime]];
    return [self UKDateTimeStamp:time andTimeStatus:status];
}

+ (NSString *)UKDatenoTime:(NSString *)notime offTime:(NSString *)offtime{
    if ([notime isKindOfClass:[NSNull class]]) {
        notime = @"";
    }
    if ([offtime isKindOfClass:[NSNull class]]) {
        offtime = @"";
    }
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:notime];
    NSDate *date2 = [formatter dateFromString:offtime];

    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *hhh = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 5.输出结果
    //    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    //
    NSRange rangedate = NSMakeRange(5,5);
    NSString * Maxday = [offtime substringWithRange:rangedate];
    
    if (hhh.year == 0) {
        if (hhh.month == 0) {
            if (hhh.day == 0) {
                if (hhh.hour == 0) {
                    if (hhh.minute == 0) {
                        if (hhh.second == 0) {
                            return @"";
                        }else{
//                            NSString *second = [NSString stringWithFormat:@"%ld秒前",(long)hhh.second];
//                            second=[second stringByReplacingOccurrencesOfString:@"-"withString:@""];
                            return @"刚刚";
                        }
                    }else{
                        NSString *minute = [NSString stringWithFormat:@"%ld分钟前",(long)hhh.minute];
                        minute=[minute stringByReplacingOccurrencesOfString:@"-"withString:@""];
                        return minute;
                    }
                }else{
                    NSString *hours = [NSString stringWithFormat:@"%ld小时前",(long)hhh.hour];
                    hours=[hours stringByReplacingOccurrencesOfString:@"-"withString:@""];
                    return hours;
                }
            }else{
                return Maxday;
            }
        }else{
            return Maxday;
        }
    }else{
        return Maxday;
    }
}
+ (NSString *)UKDateTimeStamp:(NSString *)strTime andTimeStatus:(NSString *)status
{
    if ([strTime isKindOfClass:[NSNull class]]) {
        strTime = @"";
    }
    NSTimeInterval time=[strTime doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    if ([status isEqualToString:@"yyyy-MM-dd"])
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    }else if ([status isEqualToString:@"MM月dd日"])
    {
        [dateFormatter setDateFormat:@"MM月dd日"];
    }
    else if ([status isEqualToString:@"yyyy.MM.dd"])
    {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    else if([status isEqualToString:@"yyyy/MM/dd"])
    {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    else if([status isEqualToString:@"MM/dd"])
    {
        [dateFormatter setDateFormat:@"MM/dd"];
    }
    else if([status isEqualToString:@"HH:mm"])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if([status isEqualToString:@"MM-dd HH:mm"])
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }
    else if([status isEqualToString:@"yyyy-MM-dd HH:mm"])
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if([status isEqualToString:@"yyyy年MM月dd日 HH:mm"])
    {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

+ (NSString *)UKDateTime:(NSString *)strDate andTimeStatus:(NSString *)status {
    return @"";
}

+ (NSString *)UKToTimeStatus:(NSString *)status{
    NSDate *  timeDate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    if ([status isEqualToString:@"yyyy-MM-dd"])
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if ([status isEqualToString:@"MM月dd日"])
    {
        [dateformatter setDateFormat:@"MM月dd日"];
    }
    else if ([status isEqualToString:@"yyyy.MM.dd"])
    {
        [dateformatter setDateFormat:@"yyyy.MM.dd"];
    }
    else if([status isEqualToString:@"HH:mm"])
    {
        [dateformatter setDateFormat:@"HH:mm"];
    }
    else if([status isEqualToString:@"HH:mm:ss"])
    {
        [dateformatter setDateFormat:@"HH:mm:ss"];
    }
    else if([status isEqualToString:@"MM/dd"])
    {
        [dateformatter setDateFormat:@"MM/dd"];
    }
    else if([status isEqualToString:@"MM-dd HH:mm"])
    {
        [dateformatter setDateFormat:@"MM-dd HH:mm"];
    }
    else if([status isEqualToString:@"yyyy-MM-dd HH:mm"])
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if([status isEqualToString:@"yyyy/MM/dd HH:mm"])
    {
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    else if([status isEqualToString:@"yyyy-MM-dd-HH-mm-ss"])
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    }
    else
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString * locationString = [dateformatter stringFromDate:timeDate];

    return locationString;
}

+ (NSString *)UKUp_ToTimeStatus:(NSString *)status{
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    if ([status isEqualToString:@"yyyy-MM-dd"])
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if([status isEqualToString:@"HH:mm"])
    {
        [dateformatter setDateFormat:@"HH:mm"];
    }
    else if([status isEqualToString:@"MM/dd"])
    {
        [dateformatter setDateFormat:@"MM/dd"];
    }
    else if([status isEqualToString:@"MM-dd HH:mm"])
    {
        [dateformatter setDateFormat:@"MM-dd HH:mm"];
    }else if([status isEqualToString:@"yyyy-MM-dd HH:mm"])
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString * locationString = [dateformatter stringFromDate:yesterday];

    return locationString;
}


//计算  距离现在的时间
+ (NSString *)UKDatecompareDate:(NSString *)notime{
    if ([notime isKindOfClass:[NSNull class]]) {
        notime = @"";
    }
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:notime];
    
    //今天和昨天
    NSRange range = NSMakeRange(11,5);
    NSString * toORsyesterday = [notime substringWithRange:range];
    //其它
    NSRange rangedate = NSMakeRange(5,11);
    NSString * dateday = [notime substringWithRange:rangedate];
    
    //创建要拿出的天
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return [NSString stringWithFormat:@"今天 %@",toORsyesterday];
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return [NSString stringWithFormat:@"昨天 %@",toORsyesterday];
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return [NSString stringWithFormat:@"明天 %@",toORsyesterday];
    }
    else
    {
        return dateday;
    }
}

//计算两个时间的相差值（可以直接时间戳相减）
+ (NSString *)ukdatetimeonline:(NSString *)online{
    NSTimeInterval oninterval = [online doubleValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    NSInteger date =  oninterval - interval;
    if (date <= 0) {
        return @"00:00:00";
    }else{
        NSInteger h = date / 3600;
        NSInteger m = (date - (h * 3600))/60;
        NSInteger s = (date - (h * 3600)) - (m * 60);
        NSString *dateString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"-"withString:@""];
        
        return dateString;
    }
}

#pragma mark - 将某个时间转化成 时间戳
+(NSInteger)ukTimeSwitchTimestamp:(NSString *)formatTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
}

//获取当前时间戳  （以毫秒为单位）
+ (NSInteger)ukGetNowTimeTimesta{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间

//    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    return timeSp;
}

- (NSString *)checkTheDate:(NSString *)string{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    //    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];// 今天
    //    - (BOOL)isDateInYesterday:(NSDate *)date; //判断一个日期是否是昨天
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];//昨天
    //    - (BOOL)isDateInTomorrow:(NSDate *)date;//判断一个日期是否是明天
    //    BOOL Tomorrow = [[NSCalendar currentCalendar] isDateInTomorrow:date];//明天
    NSString *day = nil;
    if (isYesterday) {
        day = @"isYesterday";
    }else {
        day = @"isToday";
    }
    return day;
}

//获取系统是24小时制或者12小时制
+ (BOOL)ukHasAMPM {
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA =[formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM =containsA.location != NSNotFound;
    return hasAMPM;
}

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    
    NSString *timeStr;
    
    if (day != 0) {
        timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒",day,house,minute,second];
    }
    else if (day==0 && house !=0) {
        timeStr = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",house,minute,second];
    }
    else if (day==0 && house==0 && minute!=0) {
        timeStr = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
    }
    else{
        timeStr = [NSString stringWithFormat:@"%zd秒",second];
    }
    
    return timeStr;
}

+ (NSString *)ukScope:(NSInteger)scopeNum enterTime:(NSString *)enterTime_c endTime:(NSString *)endTime_c {
    //一、判断当前时间是否大于开始时间
    //1.0：如果小于当前时间，则比较相差多少天，如果number天之内显示【多少天后开始】
    //2.0：如果大于当前时间，并且离结束时间在number之外显示【进行中】，之内则显示【多少天后截止】
    //二、判断当前时间是否大于结束时间，则已截止
    //三、当前时间离开始时间大于number天，则显示日期
    
    NSInteger dateTime_c = [UKDateTime ukGetNowTimeTimesta];
    //
    NSString * dateTime = [UKDateTime UKToTimeStatus:@"yyyy-MM-dd HH:mm"];
    NSString * enterTime = [UKDateTime UKDateTimeStamp:enterTime_c andTimeStatus:@"yyyy-MM-dd HH:mm"];
    NSString * endTime = [UKDateTime UKDateTimeStamp:endTime_c andTimeStatus:@"yyyy-MM-dd HH:mm"];
    NSString * enterTime_HH = [UKDateTime UKDateTimeStamp:enterTime_c andTimeStatus:@"MM-dd HH:mm"];
    NSString * endTime_HH = [UKDateTime UKDateTimeStamp:endTime_c andTimeStatus:@"MM-dd HH:mm"];
    // 判断已截止
    //    CGFloat endFloat = dateTime_c - endTime_c.floatValue;
    BOOL result = [endTime compare:dateTime] == NSOrderedDescending;//结束时间大于当前时间
    if(result) {
        //        CGFloat result = dateTime_c - enterTime_c.floatValue;
        BOOL result1 = [enterTime compare:dateTime] == NSOrderedDescending;
        if (result1) {// 即将开始
            //当前大于开始时间（快开始了）
            NSDate * start_time=[NSDate dateWithTimeIntervalSince1970:dateTime_c];
            NSDate * end_time=[NSDate dateWithTimeIntervalSince1970:enterTime_c.floatValue];
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *dateComponents = [cal components:unitFlags fromDate:start_time toDate:end_time options:0];
            // 月
            NSInteger month = [dateComponents month];
            // 天
            NSInteger day = [dateComponents day];
            // 小时
            NSInteger house = [dateComponents hour];
            // 分
            NSInteger minute = [dateComponents minute];
            if (month >= 1) {
                return endTime_HH;
            }
            else if(day >= 1) { //1.xxx
                if (day > scopeNum) {
                    return [NSString stringWithFormat:@"%@ - %@",enterTime_HH,endTime_HH];
                }else {
                    return [NSString stringWithFormat:@"%ld天后开始",(long)day];
                }
            } else {    //0.xxx
                if(house >= 1 && house < 24) {
                    return [NSString stringWithFormat:@"%ld小时后开始", (long)house];
                } else {
                    if (minute <=0) {
                        return [NSString stringWithFormat:@"马上开始"];
                    }else {
                        return [NSString stringWithFormat:@"%ld分钟后开始", (long)minute];
                    }
                }
            }
        }else {
            //当前小于开始时间（已经开始）
            //            _statusLabel.text=@"已经开始";
            NSDate * start_time=[NSDate dateWithTimeIntervalSince1970:dateTime_c];
            NSDate * end_time=[NSDate dateWithTimeIntervalSince1970:endTime_c.floatValue];
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *dateComponents = [cal components:unitFlags fromDate:start_time toDate:end_time options:0];
            // 月
            NSInteger month = [dateComponents month];
            // 天
            NSInteger day = [dateComponents day];
            // 小时
            NSInteger house = [dateComponents hour];
            // 分
            NSInteger minute = [dateComponents minute];
            if (month >= 1) {
                return endTime_HH;
            }
            else if(day >= 1) { //1.xxx
                if (day > scopeNum) {
                    return @"进行中";
                }else {
                    return [NSString stringWithFormat:@"%ld天后截止",(long)day];
                }
            } else {    //0.xxx
                if(house >= 1 && house < 24) {
                    return [NSString stringWithFormat:@"%ld小时后截止", (long)house];
                } else {
                    if (minute <=0) {
                        return [NSString stringWithFormat:@"马上截止"];
                    }else {
                        return [NSString stringWithFormat:@"%ld分钟后截止", (long)minute];
                    }
                }
            }
        }
    }
    else {
       return @"已截止";
    }
}

+ (NSString *)getChineseCalendarWithDate:(NSString *)date {
    
    NSArray *chineseYears = [NSArray arrayWithObjects:@"甲子",@"乙丑",@"丙寅",@"丁卯",@"戊辰",@"己巳",@"庚午",@"辛未",@"壬申",@"癸酉",@"甲戌",@"乙亥",@"丙子",@"丁丑",@"戊寅",@"己卯",@"庚辰",@"辛己",@"壬午",@"癸未",@"甲申",@"乙酉",@"丙戌",@"丁亥",@"戊子",@"己丑",@"庚寅",@"辛卯",@"壬辰",@"癸巳",@"甲午",@"乙未",@"丙申",@"丁酉",@"戊戌",@"己亥",@"庚子",@"辛丑",@"壬寅",@"癸丑",@"甲辰",@"乙巳",@"丙午",@"丁未",@"戊申",@"己酉",@"庚戌",@"辛亥",@"壬子",@"癸丑",@"甲寅",@"乙卯",@"丙辰",@"丁巳",@"戊午",@"己未",@"庚申",@"辛酉",@"壬戌",@"癸亥", nil];
    
    
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五", @"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    
    
    NSDate*dateTemp =nil;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    dateTemp = [dateFormater dateFromString:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents*localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    
    NSString*y_str = [chineseYears objectAtIndex:localeComp.year-1];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    
    NSString*d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString*Cz_str =nil;
    
    if([y_str hasSuffix:@"子"]) {
        
        Cz_str =@"鼠";
        
    }else if([y_str hasSuffix:@"丑"]){
        
        Cz_str =@"牛";
        
    }else if([y_str hasSuffix:@"寅"]){
        
        Cz_str =@"虎";
        
    }else if([y_str hasSuffix:@"卯"]){
        
        Cz_str =@"兔";
        
    }else if([y_str hasSuffix:@"辰"]){
        
        Cz_str =@"龙";
        
    }else if([y_str hasSuffix:@"巳"]){
        
        Cz_str =@"蛇";
        
    }else if([y_str hasSuffix:@"午"]){
        
        Cz_str =@"马";
        
    }else if([y_str hasSuffix:@"未"]){
        
        Cz_str =@"羊";
        
    }else if([y_str hasSuffix:@"申"]){
        
        Cz_str =@"猴";
        
    }else if([y_str hasSuffix:@"酉"]){
        
        Cz_str =@"鸡";
        
    }else if([y_str hasSuffix:@"戌"]){
        
        Cz_str =@"狗";
        
    }else if([y_str hasSuffix:@"亥"]){
        
        Cz_str =@"猪";
        
    }
    
    NSString*chineseCal_str =[NSString stringWithFormat:@"农历%@(%@)年%@%@",y_str,Cz_str,m_str,d_str];
    NSLog(@"==%@",chineseCal_str);
    return d_str;
    
}


+ (NSString*)weekdayStringFromDate:(NSString *)string {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";
    // NSString * -> NSDate *
    NSDate *data = [format dateFromString:string];
    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:data];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)ukGetWeekDayFordates {
    
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

+ (BOOL)ukGetNight {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    if (time>=19||time<=05) {
        return YES;
    }
    else{
        return NO;
    }
}


//获取最近八天时间 数组
+ (NSArray *)latelyEightTime {
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 8; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = -i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
      
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M.d"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
//        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
//        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
//        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //转换英文为中文
//        NSString *chinaStr = [self cTransformFromE:weekStr];
       
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
         [eightArr addObject:strTime];
    }
   
    return [NSArray arrayWithArray:eightArr];
}


//转换英文为中文
-(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}




@end
