//
//  JUtils.m
//  JuBaoPen
//
//  Created by hawk on 2016/12/6.
//  Copyright © 2016年 jubaopen. All rights reserved.
//

#import "JUtils.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation JUtils

/**
 字符串转字典
 */
+ (NSDictionary*)dictionaryWithUrlString:(NSString*)urlStr {
    if(urlStr && urlStr.length&& [urlStr rangeOfString:@"?"].length==1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if(array && array.count==2) {
            NSString*paramsStr = array[1];
            if(paramsStr.length) {
                NSString* paramterStr = [paramsStr stringByRemovingPercentEncoding];
                NSData *jsonData = [paramterStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                return responseDic;
            }
        }
    }
    return nil;
}

/**
 数组转字符串
 */
+ (NSString *)jsonStringWithPrettyPrint:(NSArray *)arr{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

/**
复制字符串
 */
+ (void)copyString:(NSString *_Nonnull)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    if (pasteboard == nil) {
        [OMGToast showWithText:@"复制失败"];
    }else {
        [OMGToast showWithText:@"复制成功"];
    }
}


/**
 钱包地址加隐私
 */
+ (NSString *_Nonnull)setWalletAddressNumber:(NSString *_Nonnull)number {
    NSString *card_number = number;
    
    if (card_number.length > 26) {
        NSString *firstStr = [card_number substringToIndex:12];
        NSString *lastStr = [card_number substringFromIndex:card_number.length - 12];
        return [NSString stringWithFormat:@"%@......%@", firstStr, lastStr];

    }else {
        NSInteger num = card_number.length/3;
        NSString *firstStr = [card_number substringToIndex:num];
        NSString *lastStr = [card_number substringFromIndex:num];
        return [NSString stringWithFormat:@"%@......%@", firstStr, lastStr];
    }
}

/**
 身份证加隐私
 */
+ (NSString *_Nonnull)setCardNumber:(NSString *_Nonnull)number {
    NSString *card_number = number;
    if (card_number.length < 7) {
        return card_number;
    }

    NSString *firstStr = [card_number substringToIndex:3];
    NSString *lastStr = [card_number substringFromIndex:card_number.length-3];
    
    CGFloat numLength = card_number.length - 6;
    NSString *privcyStr = @"";
    for (int i = 0; i < numLength; i ++) {
        privcyStr = [NSString stringWithFormat:@"*%@",privcyStr];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",firstStr, privcyStr, lastStr];

}

/**
 名字加隐私
 */
+ (NSString *_Nonnull)setPrivacyName:(NSString *_Nonnull)name {
    NSString *privcy_name = name;
    
    if ([privcy_name isEqualToString:@"--"]) {
        return @"--";
    }
    
    if (privcy_name.length <= 0) {
        return @"--";
    }
    
    if (privcy_name.length <= 1) {
        return name;
    }
    
    if (privcy_name.length == 2) {
        return [NSString stringWithFormat:@"*%@",[privcy_name substringFromIndex:1]];
    }
    
    NSString *firstStr = [privcy_name substringToIndex:1];
    NSString *lastStr = [privcy_name substringFromIndex:privcy_name.length-1];
    
    CGFloat numLength = privcy_name.length - 2;
    NSString *privcyStr = @"";
    for (int i = 0; i < numLength; i ++) {
        privcyStr = [NSString stringWithFormat:@"*%@",privcyStr];
    }
    return [NSString stringWithFormat:@"%@%@%@",firstStr, privcyStr, lastStr];
    
}

+ (NSString *)setLabelText:(NSString *)text withPlaceholder:(NSString *)holder {
    NSString *newText = text.length <= 0 ? holder:text;
    return newText;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSString *) getPlatformInfo{
    NSString *paltformInfo = @"";
    // 获取设备名称
    NSString *name = [[UIDevice currentDevice] name];
    // 获取设备系统名称
    NSString *systemName = [[UIDevice currentDevice] systemName];
    // 获取系统版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    // 获取设备模型
    NSString *model = [[UIDevice currentDevice] model];
    // 获取设备本地模型
    NSString *localizedModel = [[UIDevice currentDevice] localizedModel];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //    NSString *appName = infoDict[@"CFBundleName"];
    // app版本
    NSString *appVersion = infoDict[@"CFBundleShortVersionString"];
    // app build版本
    NSString *appBuild = infoDict[@"CFBundleVersion"];
    paltformInfo = [NSString stringWithFormat:@"设备名称:%@,系统名称:%@,系统版本:%@,设备模型:%@,设备本地模型:%@,app版本:%@,build版本:%@",name,systemName,systemVersion,model,localizedModel,appVersion,appBuild];
    
    return paltformInfo;
}

/**
 获取App版本信息
 */
+ (NSString *)getAppVersion{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *appVersion = infoDict[@"CFBundleShortVersionString"];
    return appVersion;
    
}

//App Name
+ (NSString *)getAppName{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *appVersion = infoDict[@"CFBundleName"];
    return appVersion;
}

/**
 获取App Build版本信息
 */
+ (NSString *)getAppBuildVersion{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *appVersion = infoDict[@"CFBundleVersion"];
    return appVersion;
}

/**
 获取App BundleIdentifier
 */
+ (NSString *)getAppBundleIdentifier{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *appVersion = infoDict[@"CFBundleIdentifier"];
    return appVersion;
}


+ (BOOL)isAllNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


/// 是否是一个数字 （包含小数）
/// @param str 字串
+ (BOOL)isNumberContainsDecimal:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"^(\\-|\\+)?\\d+(\\.\\d+)?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}





+ (BOOL)isIncludeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)string;
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+(BOOL)isPhoneNumber:(NSString *)patternStr{
    
    NSString *pattern = @"^1[3456789]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}


+ (BOOL)isTKLString:(NSString *)patternStr{
    NSString *pattern = @"([\\p{Sc}])\\w{8,12}([\\p{Sc}])";
    return [[self class] regularMatchWithPattern:pattern string:patternStr];
}

+(BOOL)detectionIsEmailQualified:(NSString *)patternStr{
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsPasswordQualified:(NSString *)patternStr{
    NSString *pattern = @"^[0-9a-zA-Z].{8,18}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)isValidVerifyCode:(NSString *)patternStr
{
    NSString *pattern = @"^\\d{4}";
    return [[self class] regularMatchWithPattern:pattern string:patternStr];
}

+ (BOOL)isValidInvatationCode:(NSString *)patternStr
{
    NSString *pattern = @"^[a-zA-Z0-9]{4}";
    return [[self class] regularMatchWithPattern:pattern string:patternStr];
}

+ (BOOL)regularMatchWithPattern:(NSString *)pattern string:(NSString *)string
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return results.count > 0;
}

+ (NSString *)bankNameWithCardNo:(NSString *)cardNo
{
    cardNo = [cardNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *banks = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *keys = [banks allKeys];
    
    __block NSString *bankName = @"其它银行";
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cardNo hasPrefix:obj]) {
            bankName = banks[obj][@"bank"];
            *stop = YES;
        }
    }];
    return bankName;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image scale:(CGFloat)scale
{
    UIImage *newimage;
    
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:(CGRect){CGPointZero, size}];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)convertToLogicSizeWithImage:(UIImage *)image screenScale:(CGFloat)scale
{
    if (!image) {
        return nil;
    }
    
    CGSize originSize = image.size;
    CGSize logicSize = (CGSize){originSize.width / scale, originSize.height / scale};
    
    UIGraphicsBeginImageContextWithOptions(logicSize, NO, 0.0);
    [image drawInRect:(CGRect){CGPointZero, logicSize}];
    
    UIImage *logicSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return logicSizeImage;
}

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
+(NSString*)MakeFileName:(NSString *)extName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString* t = [dateFormatter stringFromDate:[NSDate date]];
    NSString* retstr = [NSString stringWithFormat:@"%@%@",t,extName];
    return retstr;
}
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize

{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGRect)getCalculateRectWithString:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFontSize:(CGFloat)fontSize{
    CGSize size = CGSizeMake(width, height);
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName] context:nil];
    return rect;
}
/**
 字符数量处理
 */
+(NSUInteger) unicodeLengthOfString: (NSString *) text

{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
        
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        
        unicodeLength++;
        
    }
    
    return unicodeLength;
    
}

/**
 获取当前时间
 
 @param spTime <#spTime description#>
 @return <#return value description#>
 */
+(NSString *)getTimeString:(double )spTime{
    NSDate *fileTimeDate = [NSDate dateWithTimeIntervalSince1970:spTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* t = [dateFormatter stringFromDate:fileTimeDate];
    return t;
}

/**
 <#Description#>
 
 @param timestamp <#timestamp description#>
 @return <#return value description#>
 */
+ (NSDate *)dateFromTimestamp:(NSString *)timestamp {
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    return date;
}

/**
 获取 时间戳转换出来的date
 */
+ (NSDate *)getDateWithTimestamp:(NSString *)timestamp{
    NSTimeInterval interval = [timestamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm"];
    NSString *dateString = [formatter stringFromDate: date];
    
    NSDate *dateRe =[formatter dateFromString:dateString];
    return dateRe;
}

/**
 获取 时间戳转换出来的date 到i秒
 */
+ (NSDate *)getDateWithSecondNumbertamp:(NSString *)timestamp{
    NSTimeInterval interval = [timestamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    NSDate *dateRe =[formatter dateFromString:dateString];
    return dateRe;
}


/**
 <#Description#>
 
 @param timestamp <#timestamp description#>
 @param format <#format description#>
 @return <#return value description#>
 */
+(NSString*)stringFromTimestamp:(NSString*)timestamp dateFormat:(NSString *)format {
    NSDate * timeisdate = [self dateFromTimestamp:timestamp];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSString *destDateString = [formater stringFromDate:timeisdate];
    return destDateString;
}
#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}


//获取当前的时间
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}


//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}


/**
 多音字处理
 */
+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

#pragma mark 正则表达式
+(BOOL)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
+(BOOL)isChineseFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}

/*!
 *  将颜色转为图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    if(size.width > 0 && size.height > 0)
    {
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, (CGRect){CGPointZero, size});
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    return nil;
}
+ (void)animationView:(UIView *)aView
                fromY:(float)fromY
                  toY:(float)toY
             duration:(float)durationTime {
    
    [aView setFrame:CGRectMake(aView.frame.origin.x, fromY, aView.frame.size.width, aView.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];        // UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDelay:0.0f];                            // delay Animation
    [UIView setAnimationDuration:durationTime];
    [aView setFrame:CGRectMake(aView.frame.origin.x, toY, aView.frame.size.width, aView.frame.size.height)];
    [UIView commitAnimations];
}

+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                  toX:(float)toX
             duration:(float)durationTime {
    
    [aView setFrame:CGRectMake(fromX, aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];        // UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDelay:0.0f];                            // delay Animation
    [UIView setAnimationDuration:durationTime];
    [aView setFrame:CGRectMake(toX, aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height)];
    [UIView commitAnimations];
}

+ (void)animationViewCenter:(UIView *)aView
                      fromX:(float)fromX
                        toX:(float)toX
                   duration:(float)durationTime {
    
    //    [aView setFrame:CGRectMake(fromX, aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height)];
    aView.center = CGPointMake(fromX, aView.frame.origin.y);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];        // UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDelay:0.0f];                            // delay Animation
    [UIView setAnimationDuration:durationTime];
    //    [aView setFrame:CGRectMake(toX, aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height)];
    aView.center = CGPointMake(toX, aView.frame.origin.y);
    [UIView commitAnimations];
}
+(UIImage *)getThumbnailImage:(NSString *)videoURL type:(NSInteger )type
{
    AVURLAsset *asset;
    if(type ==1 ){ //本地
        
        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL]
                                        options:nil];
    }else{
        
        asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    }
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 15);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}


+(NSURL *)isHttpWechatImg:(NSString *)url{
    if ([url containsString:@"http"]) {
        
        return [NSURL URLWithString:url];
        
    } else {
        
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://123.207.23.184/%@",url]];
    }
}

+ (NSString *)md5:(NSString *)string{
    
    const char* str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH ;i++){
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
+ (id)storyboardWithName:(NSString *)sbname Identifier:(NSString *)identifier
{
    
    @try {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbname bundle:nil];
        
        return  [storyboard instantiateViewControllerWithIdentifier:identifier];
        
    }@catch (NSException *exception) {
        NSLog(@"Stack Trace: %@", [exception name]);
        NSLog(@"请检查sbname和identifier");
    }
}

+ (UIViewController *)viewTopViewController {
    
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+(UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


+(NSDictionary *)conversion:(NSDictionary *)params{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyStr in params.allKeys) {
        NSString *vlaue = [NSString stringWithFormat:@"%@",[params objectForKey:keyStr]];
        if (!kStringIsNull(vlaue)) {
            [mutableDic setObject:vlaue forKey:keyStr];
        }
    }
    return mutableDic;
}

+(void)alertTarget:(id)traget message:(NSString *)message title:(NSString *)title cancel:(NSString *)cancel done:(NSString *)done dBlcok:(void(^)(NSInteger index))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(0);
        }
    }];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:done
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(1);
        }
    }];
    
    ///自定义颜色
    [doneAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    [cancelAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    //修改标题
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    //     //修改message
    //    [alert setValue:alertControllerStr forKey:@"attributedMessage"];
    if (block) {
        [alert addAction:cancelAction];
    }
    [alert addAction:doneAction];
    [traget presentViewController:alert animated:YES completion:nil];
    
}

+(void)alertTarget:(id)traget message:(NSString *)message title:(NSString *)title done:(NSString *)done dBlcok:(void(^)(NSInteger index))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:done
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(0);
        }
    }];
    ///自定义颜色
    [doneAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    //修改标题
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    //     //修改message
    //    [alert setValue:alertControllerStr forKey:@"attributedMessage"];
    if (block) {
        [alert addAction:doneAction];
    }
    [traget presentViewController:alert animated:YES completion:nil];
    
//
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
}


+ (NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}


/**
 (普通)
 生成二维码
 QRStering:字符串
 imageFloat:二维码图片大小
 */

+ (UIImage *)createQRCodeWithString:(NSString *)QRString withImgSize:(CGFloat)imageFloat{
    //1.将字符串转出NSData
    NSData *img_data = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.将字符串变成二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //  条形码 filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    //3.恢复滤镜的默认属性
    [filter setDefaults];
    
    //4.设置滤镜的 inputMessage
    [filter setValue:img_data forKey:@"inputMessage"];
    
    //5.获得滤镜输出的图像
    CIImage *img_CIImage = [filter outputImage];
    //6.此时获得的二维码图片比较模糊，通过下面函数转换成高清
    UIImage *imageV = [self imageWithImageSize:imageFloat withCIIImage:img_CIImage];
    //返回二维码图像
    return imageV;
}


/**
 (中间有小图片)
 生成二维码
 QRStering:所需字符串
 centerImage:二维码中间的image对象
 */
+ (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage{
    // 创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"XiaoGuiGe"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 将字符串转换成 NSdata
    NSData *dataString = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:dataString forKey:@"inputMessage"];
    // 获得滤镜输出的图像
    CIImage *outImage = [filter outputImage];
    // 图片小于(27,27),我们需要放大
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(40, 40)];
    // 将CIImage类型转成UIImage类型
    UIImage *startImage = [UIImage imageWithCIImage:outImage];
    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    // 再把小图片画上去
    CGFloat icon_imageW = 100;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;
    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    // 获取当前画得的这张图片
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    //返回二维码图像
    return qrImage;
}

/** 将CIImage转换成UIImage 并放大(内部转换使用)*/
+ (UIImage *)imageWithImageSize:(CGFloat)size withCIIImage:(CIImage *)ciiImage {
    CGRect extent = CGRectIntegral(ciiImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciiImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 生成二维码
 带login
 */
+ (UIImage *)createQRCodeWithUrl:(NSString *)url centerImage:(NSString *)imgName {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];

    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    // 添加logo
    qrcode = [self drawImage:[UIImage imageNamed:imgName] inImage:qrcode];
    return qrcode;
}

// 将二维码转成高清的格式
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {

    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

// 添加logo
+ (UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画 自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    // 注意logo的尺寸不要太大,否则可能无法识别
    CGRect rect = CGRectMake(imageSize.width / 2 - 25, imageSize.height / 2 - 25, 50, 50);
//    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);

    [newImage drawInRect:rect];

    //返回绘制的新图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 字典转json字符串方法

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
//    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    //    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

// JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



+ (NSString *)resultStrOfTextFieldWithTextField:(UITextField *)textField range:(NSRange)range string:(NSString *)string {
    //计算结果字符串
    NSMutableString *resultStr = [NSMutableString stringWithString:textField.text];
    if (string.length == 0) {
        //减
        [resultStr deleteCharactersInRange:range];
    } else {
        //加
        if (range.length == 0) {
            
            [resultStr insertString:string atIndex:range.location];
            
        } else {
            [resultStr replaceCharactersInRange:range withString:string];
        }
    }
    
    return resultStr;
}


+ (BOOL)limitInputWithObserver:(UITextField *)observer range:(NSRange)range replacementString:(NSString *)string limitLength:(NSInteger)limitLength limitCharacterType:(LimitCharacterType)limitCharacterType {
    
    
    NSString *resultStr = [self resultStrOfTextFieldWithTextField:observer range:range string:string];
    
    for (NSInteger loopIndex = 0; loopIndex < string.length; loopIndex++) {
        
        unichar character = [string characterAtIndex:loopIndex];
        
        switch (limitCharacterType) {
            case LimitCharacterTypeNone:
            {
                
            }
                break;
            case LimitCharacterTypeJustNumber:
            {
                if (!(character >= 48 && character <= 57)) {
                    return NO;
                }
            }
                break;
            case LimitCharacterTypeJustLetter:
            {
                if (!((character >= 65 && character <= 90 ) || (character >= 97 && character <= 122))) {
                    return NO;
                }
            }
                break;
            case LimitCharacterTypeNumberAndLetter:
            {
                if (!((character >= 48 && character <= 57) || (character >= 65 && character <= 90 ) || (character >= 97 && character <= 122))) {
                    return NO;
                }
            }
                break;
            case LimitCharacterTypeNumberAndPoint:
            {
                if (!((character >= 48 && character <= 57) || character == 46)) {
                    return NO;
                }
                
                
            }
                break;
            case LimitCharacterTypePassword:
            {
                if (character == 32) {
                    return NO;
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (limitCharacterType == LimitCharacterTypeNumberAndPoint) {
        
        //如果第一位是“.”不允许
        if (resultStr.length >= 1) {
            if ([resultStr characterAtIndex:0] == 46) {
                return NO;
            }
        }
        
        //小数点后面最多两位数
        if ([resultStr containsString:@"."]) {
            if ([resultStr componentsSeparatedByString:@"."].lastObject.length >= 3) {
                return NO;
            }
        }
        
        //不允许两个“.”
        if ([[resultStr componentsSeparatedByString:@"."] count] > 2) {
            return NO;
        }
        
    }
    
    //限制长度
    if (resultStr.length > limitLength) return NO;
    
    
    return YES;
}




///判断是否输入的是网址地址
+ (BOOL)isUrlAddress:(NSString*)url{
    NSString*reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate*urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return[urlPredicate evaluateWithObject:url];
    
}

///判断是否为社会信用代码
+ (BOOL)isSocialCredit18Number:(NSString *)socialCreditNum
{
    if(socialCreditNum.length != 18){
        return NO;
    }
    
    NSString *scN = @"^([0-9ABCDEFGHJKLMNPQRTUWXY]{2})([0-9]{6})([0-9ABCDEFGHJKLMNPQRTUWXY]{9})([0-9Y])$";
    NSPredicate *regextestSCNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", scN];
    if (![regextestSCNum evaluateWithObject:socialCreditNum]) {
        return NO;
    }
    
    NSArray *ws = @[@1,@3,@9,@27,@19,@26,@16,@17,@20,@29,@25,@13,@8,@24,@10,@30,@28];
    NSDictionary *zmDic = @{@"A":@10,@"B":@11,@"C":@12,@"D":@13,@"E":@14,@"F":@15,@"G":@16,@"H":@17,@"J":@18,@"K":@19,@"L":@20,@"M":@21,@"N":@22,@"P":@23,@"Q":@24,@"R":@25,@"T":@26,@"U":@27,@"W":@28,@"X":@29,@"Y":@30};
    NSMutableArray *codeArr = [NSMutableArray array];
    NSMutableArray *codeArr2 = [NSMutableArray array];
    
    codeArr[0] = [socialCreditNum substringWithRange:NSMakeRange(0,socialCreditNum.length-1)];
    codeArr[1] = [socialCreditNum substringWithRange:NSMakeRange(socialCreditNum.length-1,1)];
    
    int sum = 0;
    
    for (int i = 0; i < [codeArr[0] length]; i++) {
        
        [codeArr2 addObject:[codeArr[0] substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSScanner* scan;
    int val;
    for (int j = 0; j < codeArr2.count; j++) {
        scan = [NSScanner scannerWithString:codeArr2[j]];
        if (![scan scanInt:&val] && ![scan isAtEnd]) {
            codeArr2[j] = zmDic[codeArr2[j]];
        }
    }
    
    
    for (int x = 0; x < codeArr2.count; x++) {
        sum += [ws[x] intValue]*[codeArr2[x] intValue];
    }
    
    
    int c18 = 31 - (sum % 31);
    
    for (NSString *key in zmDic.allKeys) {
        
        if (zmDic[key]==[NSNumber numberWithInt:c18]) {
            if (![codeArr[1] isEqualToString:key]) {
                return NO;
            }
        }
    }
    
    return YES;
}



///压缩图片
+ (UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    CGSize croppedSize;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    if (imageWidth > imageHeight) {
        offsetX = (imageWidth -imageHeight) / 2;
        croppedSize = CGSizeMake(imageHeight, imageHeight);
    } else {
        offsetY = (imageHeight-imageWidth) / 2;
        croppedSize = CGSizeMake(imageWidth, imageWidth);
    }
    CGRect clippedRect = CGRectMake(offsetX, offsetY, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    
    float ratio = croppedSize.width>SCREEN_WIDTH?SCREEN_WIDTH:croppedSize.width;
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    return thumbnail;
}


///富文本加载html
+ (NSMutableAttributedString *)setAttributedString:(NSString *)str withfont:(UIFont *)font withWidth:(CGFloat)width withtextColor:(UIColor *)color
{
    //如果有换行，把\n替换成<br/>
    //如果有需要把换行加上
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    //设置HTML图片的宽度
    str = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@",width,str];
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    //设置富文本字的大小
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    ///字体颜色
    [htmlString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    //    paragraphStyle.alignment = NSTextAlignmentJustified;
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    
    return htmlString;
}

///计算html的高度
+ (NSInteger)hideLabelLayoutHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;  // 段落高度
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:content];
    
    [attributes addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:mFontSize] range:NSMakeRange(0, content.length)];
    [attributes addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return attSize.height;
}




///json字符串转数组
+ (NSArray *)stringToJSON:(NSString *)jsonStr{
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                return tmp;
            } else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]) {
                return [NSArray arrayWithObject:tmp];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

#pragma mark ---- 将时间戳转换成时间------13位
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark ---- 将时间戳转换成时间 指定分隔符------13位
+ (NSString *)getTimeFromTimestampFarmat:(NSString *)timestamp separator:(NSString *)separator{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"YYYY%@MM%@dd",separator,separator]];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark ---- 将时间戳转换成时间------10位
+ (NSString *)getTimeFromTimeTen:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark ---- 将时间戳转换成时间------10位----几月几日
+ (NSString *)getStringTimeFromTimeTen:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}



#pragma mark ---- 将时间戳转换成时间------13位
+ (NSString *)getTimeFromTimestampHHMMSS:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}


#pragma mark ---- 将时间戳转换成时间 自定义格式 ----13位
+ (NSString *)getTimeFromTimestampFromat:(NSString *)timestamp format:(NSString *)format{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark ---- 将时间戳转换成时间------13位
+ (NSString *)getTimeFromTimestampHHMM:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}


#pragma mark ---- 将时间戳转换成时间--时分秒----13位
+ (NSString *)getTimeFromTimestampVehicle:(NSString *)timestamp{
    //将对象类型的时间转换为NSDate类型
    double time = [timestamp doubleValue];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}


//设置圆角
+ (CAShapeLayer *)setCornerRadiusWithBezier:(CGRect)aRect byCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aRect byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = aRect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}



+(NSString *)getStringTextFieldFormatWith:(NSString *)textField replacementString:(NSString *)string{
    NSString *txt = [textField mutableCopy];
    //字符串拼接
    if ([string isEqualToString:@""]) {
        if (txt.length > 1) {
            txt = [txt substringToIndex:txt.length - 1];
        }else if (txt.length == 1){
            txt = @"";
        }
    }else{
        txt = [txt stringByAppendingString:string];
    }
    return txt;
}


/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

/**
 dateString = 2017-01-01 21:05:10
 formate = yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)formateDate:(NSString *)dateString
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)showTimeFromTimestamp:(NSString *)timestamp{
    
    //    @try {
    //
    //        long temp_time_stamp = timestamp.longValue;
    //
    //        //timestamp 的时间
    //        NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:temp_time_stamp/1000];
    //        //当前时间
    //        NSDate *nowDate = [NSDate date];
    //        //0点时间
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //        NSString *zeroDateStr = [NSString stringWithFormat:@"%ld-%2ld-%2ld 00:00:00",(long)nowDate.year,(long)nowDate.month,(long)nowDate.day];
    //        NSDate *zeroDate = [dateFormatter dateFromString:zeroDateStr];
    //
    //        //timestamp距当前时间的时间间隔
    //        NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:myDate];
    //        //timestamp距当前时间所在日期的零点的时间间隔
    //        NSTimeInterval zeroTimeInterval = [zeroDate timeIntervalSinceDate:myDate];
    //
    //        NSString *dateStr = @"";
    //
    //        long oneDay = 86400;
    //        long oneHour = 3600;
    //        long oneMinute = 60;
    //
    //        //今天之内
    //        if ([myDate isToday]) {
    //
    //            if (timeInterval < oneMinute) {
    //
    //                dateStr = @"刚刚";
    //
    //            }else if (timeInterval >= oneMinute && timeInterval < oneHour){
    //
    //                int mins = timeInterval/60;
    //                dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
    //
    //            }else if (timeInterval >= oneHour && timeInterval < oneDay){
    //
    //                int hour = timeInterval/oneHour;
    //                dateStr = [NSString stringWithFormat:@"%d小时前",hour];
    //
    //            }else{
    //
    //                dateStr = @"";
    //            }
    //
    //        }
    //        //昨天
    //        else if (zeroTimeInterval > 0 && zeroTimeInterval <= oneDay){
    //
    //            dateStr = @"昨天";
    //        }
    //        //前天
    //        else if (zeroTimeInterval > oneDay && zeroTimeInterval <= oneDay * 2){
    //
    //            dateStr = @"前天";
    //        }
    //        //两天前
    //        else if (zeroTimeInterval > oneDay * 2 && zeroTimeInterval <= oneDay * 3){
    //
    //            dateStr = @"两天前";
    //        }
    //        //三天前
    //        else if (zeroTimeInterval > oneDay * 3 && zeroTimeInterval <= oneDay * 4){
    //
    //            dateStr = @"三天前";
    //        }
    //        //四天前
    //        else if (zeroTimeInterval > oneDay * 4 && zeroTimeInterval <= oneDay * 5){
    //
    //            dateStr = @"四天前";
    //        }
    //        //五天前
    //        else if (zeroTimeInterval > oneDay * 5 && zeroTimeInterval <= oneDay * 6){
    //
    //            dateStr = @"五天前";
    //        }
    //        //六天前
    //        else if (zeroTimeInterval > oneDay * 6 && zeroTimeInterval <= oneDay * 7){
    //
    //            dateStr = @"六天前";
    //        }
    //        //一周前
    //        else if (zeroTimeInterval > oneDay * 7 && zeroTimeInterval <= oneDay * 8){
    //
    //            dateStr = @"一周前";
    //        }
    //        //展示日期
    //        else{
    //
    //            dateStr = [NSString stringWithFormat:@"%ld-%2ld-%2ld 00:00:00",(long)myDate.year,(long)myDate.month,(long)myDate.day];
    //        }
    //
    //        return dateStr;
    //
    //    } @catch (NSException *exception) {
    //
    //        return @"";
    //
    //    }
    
    return nil;
}


///判断输入到TextField的内容是不是数字
+ (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//匹配相应的字符串
+(NSArray *_Nonnull)RegulaString:(NSString *_Nonnull)String{
    
    if (String.length == 0) {
        return nil;
    }
    NSString *str = String;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]*" options:0 error:NULL];
    NSArray <NSTextCheckingResult *>*textArray = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray *strArray = [NSMutableArray array];
    for (NSTextCheckingResult *result in textArray) {
        NSRange range = result.range;
        if (range.length != 0) {
            [strArray addObject:[str substringWithRange:range]];
        }
    }
    return strArray;
}

//金额的格式转化
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str{
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    return money;
}


//是否两位或一位小数点为零
+ (NSString *)hasDecimal:(NSString *)string{
    if (NULLString(string)) {
        return @"0";
    }
    
    if ([string componentsSeparatedByString:@"."].count == 2) {
        
        NSString *last = [string componentsSeparatedByString:@"."].lastObject;
        if ([last isEqualToString:@"00"]) {
            string = [string substringToIndex:string.length - (last.length + 1)];
            return string;
        }else if([last isEqualToString:@"0"]){
            
            string = [string substringToIndex:string.length - (last.length + 1)];
            return string;
            
        }else{
            
            if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                string = [string substringToIndex:string.length - 1];
                return string;
            }
        }
    }
    return string;
    
    
    //    NSString *str;
    //    if ([string hasSuffix:@".00"]) {
    //        str = [string substringToIndex:string.length - 3];
    //    }else{
    //        str = string;
    //    }
    //
    //    return str;
}

/*
 金额展示优化
 要求保留最多两位小数，且四舍不入，若第二位小数为0则去掉，若两位小数都为0则只保留整数部分*/

+ (NSString *)reviseDoubleValue:(double)price{
    //    NSLog(@"reviseDoubleValue --------->:%lf",price);
    
    //    NSString *sting = [NSString stringWithFormat:@"%0.3lf",price];
    //    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //    formatter.roundingMode = NSNumberFormatterRoundDown;//NSNumberFormatterRoundFloor; NSNumberFormatterRoundDown
    //    formatter.maximumFractionDigits = 2;  //保留最多两位小数（99.00->99;99.01->99.01;99.10->99.1）
    //    return [formatter stringFromNumber:@([sting doubleValue])];
    
    NSString *sting = [NSString stringWithFormat:@"%0.3lf",price];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"####.##;"];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    return [formatter stringFromNumber:@([sting doubleValue])];
}



/*
 从字典取出NSNumber/NSString转换为NSDecimalNumber
 */
+ (NSDecimalNumber *)decimalNumberFromDict:(NSDictionary *)dict withKey:(NSString *)key{
    
    id objc = dict[key];
    NSDecimalNumber *returnDecimalNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    if ([objc isKindOfClass:[NSString class]]) {
        
        NSString *tempStr = (NSString *)objc;
        returnDecimalNumber = [NSDecimalNumber decimalNumberWithString:tempStr];
        
    }else if ([objc isKindOfClass:[NSNumber class]]){
        
        NSNumber *tempNumber = (NSNumber *)objc;
        NSString *returnStr = [NSString stringWithFormat:@"%0.2f",tempNumber.doubleValue];
        returnDecimalNumber = [NSDecimalNumber decimalNumberWithString:returnStr];
        
    }
    return returnDecimalNumber;
}

/*
 转换commissionRate为标准的金额格式NSDecimalNumber
 */
+ (NSDecimalNumber *)decimalNumberWithCommissionRate:(NSString *)commissionRate{
    
    CGFloat commissionRateValue = commissionRate.doubleValue/100.0;
    NSDecimalNumber *commissionRateNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.8f",commissionRateValue]];
    return commissionRateNumber;
}


+ (BOOL)checkPassword:(NSString*) password
{
    
    NSString *pattern =@"^[a-zA-Z0-9]{1,18}";//^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
    
}

#pragma mark - 获取设备当前网络IP地址
+(NSString *_Nullable)getIPAddress;
{
    NSArray *searchArray = YES ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //    JZLog(@"addresses: %@", addresses);
    
    if([addresses objectForKey:@"en2/ipv4"]){
        return addresses[@"en2/ipv4"];
    }
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
        address = addresses[key];
        //筛选出IP地址格式
        if([self isValidatIP:address]) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            //            JZLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark 获取唯一uuID
+ (NSString *)uuidString {
//    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
//    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
//    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
//    CFRelease(uuid_ref);
//    CFRelease(uuid_string_ref);
//    return [uuid lowercaseString];
    return [[NSUUID UUID] UUIDString];
}

//设备型号
+ (NSString *)deviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    //------------------------------iPhone---------------------------
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"] ||
        [platform isEqualToString:@"iPhone3,2"] ||
        [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"] ||
        [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"] ||
        [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"] ||
        [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"] ||
        [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"] ||
        [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"] ||
        [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"] ||
        [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"] ||
        [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    
    //------------------------------iPad--------------------------
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"] ||
        [platform isEqualToString:@"iPad2,2"] ||
        [platform isEqualToString:@"iPad2,3"] ||
        [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"] ||
        [platform isEqualToString:@"iPad3,2"] ||
        [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"] ||
        [platform isEqualToString:@"iPad3,5"] ||
        [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"] ||
        [platform isEqualToString:@"iPad4,2"] ||
        [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"] ||
        [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"] ||
        [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad6,7"] ||
        [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([platform isEqualToString:@"iPad6,11"] ||
        [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,11"] ||
        [platform isEqualToString:@"iPad7,12"]) return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,1"] ||
        [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([platform isEqualToString:@"iPad7,3"] ||
        [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    //------------------------------iPad Mini-----------------------
    if ([platform isEqualToString:@"iPad2,5"] ||
        [platform isEqualToString:@"iPad2,6"] ||
        [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad4,4"] ||
        [platform isEqualToString:@"iPad4,5"] ||
        [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"] ||
        [platform isEqualToString:@"iPad4,8"] ||
        [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"] ||
        [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    //------------------------------iTouch------------------------
    if ([platform isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iTouch6";
    
    //------------------------------AppleTV------------------------
    if ([platform isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    //------------------------------Samulitor-------------------------------------
    if ([platform isEqualToString:@"i386"] ||
        [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}


//计算字符串的高度
+ (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

//计算字符串的宽度
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.width);
}

///富文本加载html
+ (NSMutableAttributedString *)setAttributedString:(NSString *)str withfont:(UIFont *)font withWidth:(CGFloat)width
{
    //如果有需要把换行加上
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    NSString *first = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><style>*{ width: 100%%; margin: 0; padding: 0 3; box-sizing: border-box;} img{ width: %f;}</style></head><body>%@</body></html>",width,str];
    
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[first dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    //设置富文本字的大小
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    
    return htmlString;
}


/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
+ (CGFloat)getSpaceLabelHeightwithString:(NSString *)content withTextFontSize:(CGFloat)mFontSize withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 0;  // 段落高度
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:content];
    
    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:mFontSize] range:NSMakeRange(0, content.length)];
    [attributes addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return attSize.height;
}

/**
 *  随机获取数组里面的元素
 */
+(NSDictionary *)getRandomItem:(NSMutableArray *)arr{
    if (arr.count <= 0) {
        return nil;
    }
    int index =  [self getRandomNumber:0 to:(unsigned)arr.count-1];
    NSDictionary *dic = arr[index];
    return dic;
}

+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

//替换HTML中的格式 
+(NSString *)getHtmlStringFormatWithString:(NSString *)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"width:auto" withString:@"width:100%"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"width: auto" withString:@"width:100%"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"src=\"http://" withString:@"style=\"width:100%\" src=\"http://"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"style=\"width:100%\" src=\"http://"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"style=\"\"" withString:@"style=\"width:100%\""];
    return htmlString;
}

//HTML适配图片文字
+ (NSMutableString *_Nullable)adaptWebViewForHtml:(NSString *)htmlStr
{
    
    //    "    <script>\n" +
    //    "\n" +
    //    "        window.onload = function () {\n" +
    //    "            /*720代表设计师给的设计稿的宽度，你的设计稿是多少，就写多少;100代表换算比例，这里写100是\n" +
    //    "              为了以后好算,比如，你测量的一个宽度是100px,就可以写为1rem,以及1px=0.01rem等等*/\n" +
    //    "            getRem(375, 100)\n" +
    //    "        };\n" +
    //    "        window.onresize = function () {\n" +
    //    "            getRem(375, 100)\n" +
    //    "        };\n" +
    //    "\n" +
    //    "        function getRem(pwidth, prem) {\n" +
    //    "            var html = document.getElementsByTagName(\"html\")[0];\n" +
    //    "            var oWidth = document.body.clientWidth || document.documentElement.clientWidth;\n" +
    //    "            html.style.fontSize = oWidth / pwidth * prem + \"px\";\n" +
    //    "        }\n" +
    //    "\n" +
    //    "    </script>  <style>\n" +
    //    "        *{\n" +
    //    "            font-size: 14px;\n" +
    //    "        }\n" +
    //    "    </style>\n" +
    
    
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html lang=\"en\">\n" ];
    
    [headHtml appendString : @"<head>\n" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">\n" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />\n" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />\n" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />\n" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />\n" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //   适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>\n"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>\n" ];
    [headHtml appendString : @"<title>webview</title>\n" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
}


//数组转json字符串
+ (NSString *)pictureArrayToJSON:(NSArray *)picArr {
    NSData *data=[NSJSONSerialization dataWithJSONObject:picArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    //去除空格和回车：
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"jsonStr==%@",jsonStr);
    return jsonStr;
}



//获赞数量--超出1万时显示为带“w”的数据，保留1位小数，例如：1.2w、12.8w
+ (NSString *)numberChangeString:(NSString *)floatNumber{
    
    NSString *numberString;
    
    if (floatNumber.length == 0) {
        numberString = @"";
    }
    
    if (floatNumber.doubleValue >= 10000) {
        
        float wan = floatNumber.doubleValue / 10000;
        
        NSString *string = [NSString stringWithFormat:@"%.1lf",wan];
        
        //        NSDecimalNumber *currentPrice = [NSDecimalNumber decimalNumberWithString:floatNumber];
        //        currentPrice = [currentPrice decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]];
        //        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //        [formatter setPositiveFormat:@"########.#;"];
        //        formatter.roundingMode = NSNumberFormatterRoundDown;
        //        NSString *currentPriceString = [formatter stringFromNumber:currentPrice];
        
        numberString = [NSString stringWithFormat:@"%@w",[JUtils hasDecimal:string]];
        
    }else{
        
        numberString = floatNumber;
    }
    
    return numberString;
}

+(NSString *)getURLBySplicingParam:(NSString *)url parm:(NSDictionary *)dic{
    
    if (![url containsString:@"http"]) {
        return Nil;
    }
    
    if (!dic) {
        return Nil;
    }
    
    if (dic.count <= 0) {
        return Nil;
    }
    
    NSMutableArray *arrKey = [NSMutableArray arrayWithArray:[dic allKeys]];
    if (![arrKey.firstObject isKindOfClass:[NSString class]]) {
        return Nil;
    }
    NSString *resultURL = [url mutableCopy];

    for (NSInteger i = 0; i < arrKey.count; i++) {

        NSString *key = arrKey[i];
        NSString *key1 = [NSString stringWithFormat:@"&%@=",key];
        NSString *key2 = [NSString stringWithFormat:@"?%@=",key];

        if (!([url containsString:key1] || [url containsString:key2])) {
            NSString *value = dic[key];
            if ([resultURL containsString:@"?"]) {
                resultURL = [resultURL stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
            }else{
                resultURL = [resultURL stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
            }
        }
    }

    return resultURL;
}



+ (CGRect)stringWidthRectWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font {
    NSDictionary * attributes = @{NSFontAttributeName: font};
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}



/*
 *  设置行间距和字间距
 *
 *  @param string    字符串
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *  @param font      字体大小
 *
 *  @return 富文本
 */
+ (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

/**
 *正则匹配用户密码6-20位数字和字母组合
 *数字+字母 且不小于8位
 */
+ (BOOL)checkAandStrPassword:(NSString *)password
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
    
    BOOL result = false;
    if ([password length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}

/**
 *正则匹配用户密码6-20位数字、字母、字符任意两种组合
 *数字+字母 且不小于8位
 */
+ (BOOL)checkTZLoginPassword:(NSString *)password
{
    BOOL result = false;
    if ([password length] >= 8 && [password length] <= 20){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[A-Za-z0-9\\W]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}

/**
 设置蓝牙(开关)
*/
+ (void)setBluetoothDevices {
    NSString *str1 = @"fs:r";
    NSString *str2 = @"TION";
    NSString *str3 = @"CES";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"App-Pre%@ootLOCA%@SERVI%@",str1,str2,str3]];
    if( [[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


/**
 十六进制转换为数字   (转十进制)
 */
+ (NSString *)numberWithHexString:(NSString *)hexString {

//    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
//
//    int hexNumber;
//
//    sscanf(hexChar, "%x", &hexNumber);
    
    NSString *serialStr = [NSString stringWithFormat:@"%lu",strtoul([hexString UTF8String],0,16)];
    return serialStr;
}


//=========================================连心桥=================================
//从缓存中获取存入的变量，传递给小程序
+ (NSMutableDictionary *)getAllPrefs
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    NSMutableDictionary *filteredPrefs = [NSMutableDictionary dictionary];
    if (prefs != nil) {
        for (NSString *candidateKey in prefs) {
            if ([candidateKey hasPrefix:@"flutter."]) {
                [filteredPrefs setObject:prefs[candidateKey] forKey:candidateKey];
            }
        }
    }
    return filteredPrefs;
}


+ (NSString *)convertDataToHexStr:(NSData *)data{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

//4个字节Bytes 转 int
unsigned int  TCcbytesValueToInt(Byte *bytesValue) {
    unsigned int  intV;
    intV = (unsigned int ) ( ((bytesValue[3] & 0xff)<<24)
                            |((bytesValue[2] & 0xff)<<16)
                            |((bytesValue[1] & 0xff)<<8)
                            |(bytesValue[0] & 0xff));
    return intV;
}



/**
 整型转二进制字符串（00000000|00000000|00000000|00000001）
 */
+ (NSString *)intToBinaryString:(int)intValue{
    int byteBlock = 8,    // 每个字节8位
    totalBits = sizeof(int) * byteBlock, // 总位数（不写死，可以适应变化）
    binaryDigit = 1;  // 当前掩（masked）位
    NSMutableString *binaryStr = [[NSMutableString alloc] init];   // 二进制字串
    do
    {
        // 检出下一位，然后向左移位，附加 0 或 1
        [binaryStr insertString:((intValue & binaryDigit) ? @"1" : @"0" ) atIndex:0];
        // 若还有待处理的位（目的是为避免在最后加上分界符），且正处于字节边界，则加入分界符|
        if (--totalBits && !(totalBits % byteBlock))
            [binaryStr insertString:@"|" atIndex:0];
        // 移到下一位
        binaryDigit <<= 1;
    } while (totalBits);
    // 返回二进制字串
    return binaryStr;
}
/**
 整型转二进制字符串（00000000000000000000000000000001）
 */
+ (NSString *)intToBinary:(int)intValue{
    int byteBlock = 8,            // 8 bits per byte
    totalBits = (sizeof(int)) * byteBlock, // Total bits
    binaryDigit = totalBits; // Which digit are we processing   // C array - storage plus one for null
    char ndigit[totalBits + 1];
    while (binaryDigit-- > 0)
    {
        // Set digit in array based on rightmost bit
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        // Shift incoming value one to right
        intValue >>= 1;  }   // Append null
    ndigit[totalBits] = 0;
    // Return the binary string
    return [NSString stringWithUTF8String:ndigit];
}

// base64编码
+ (NSString*)base64encode:(NSString*)str {
    // 1.把字符串转成二进制数据
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 2.将二进制进行base64加密(编码)
    // iOS7以后才有的方法
    return [data base64EncodedStringWithOptions:0];

}

// base64解码

+ (NSString*)base64Decode:(NSString*)str {

    

    // 1.先把base64编码后的字符串转成二进制数据

    NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:0];

    

    // 2.把data转成字符串

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

// 秘钥key
NSString *AESKey = @"compassplatform0";
/**
 * AES加密
 */
+ (NSString *)encryptAESCBC:(NSString *)inputString

{
    
    NSMutableData *inputData = [NSMutableData dataWithData: [inputString dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData *outData = [self CBCWithOperation: kCCEncrypt andIv:@"compassplatform0" andKey:AESKey andInput: inputData];
    
    outData = [outData base64EncodedDataWithOptions: NSDataBase64EncodingEndLineWithLineFeed];
    
    return [[NSString alloc] initWithData: outData encoding: NSUTF8StringEncoding] ?: @"";
    
}






+ (NSData *)CBCWithOperation:(CCOperation)operation andIv:(NSString *)ivString andKey:(NSString *)keyString andInput:(NSData *)inputData

{
    
    const char *iv = [[ivString dataUsingEncoding: NSUTF8StringEncoding] bytes]; const char *key = [[keyString dataUsingEncoding: NSUTF8StringEncoding] bytes];
    
    CCCryptorRef cryptor;
    
    CCCryptorCreateWithMode(operation, kCCModeCFB, kCCAlgorithmAES, ccNoPadding, iv, key, [keyString length], NULL, 0, 0, 0, &cryptor);
    
    NSUInteger inputLength = inputData.length;
    
    char *outData = malloc(inputLength);
    
    memset(outData, 0, inputLength);
    
    size_t outLength = 0;
    
    CCCryptorUpdate(cryptor, inputData.bytes, inputLength, outData, inputLength, &outLength);
    
    NSData *data = [NSData dataWithBytes: outData length: outLength];
    
    CCCryptorRelease(cryptor);
    
    free(outData);
    
    return data;
    
}


/**
 * AES解密
 */
+ (NSString *)aesDecrypt:(NSString *)secretStr{
    if (!secretStr) {
        return nil;
    }
    //先对加密的字符串进行base64解码
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:secretStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
     
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [AESKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
     
    NSUInteger dataLength = [decodeData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [decodeData bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return result;
    } else {
        free(buffer);
        return nil;
    }
}



@end

