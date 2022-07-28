//
//  JUtils.h
//  JuBaoPen
//
//  Created by hawk on 2016/12/6.
//  Copyright © 2016年 jubaopen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <MJExtension/MJExtension.h>
#import "JZEnumMacros.h"


typedef NS_ENUM(NSInteger, LimitCharacterType) {
    LimitCharacterTypeNone,
    LimitCharacterTypeJustNumber,
    LimitCharacterTypeJustLetter,
    LimitCharacterTypeNumberAndLetter,
    LimitCharacterTypeNumberAndPoint,
    LimitCharacterTypePassword
};

typedef void(^ _Nullable blockSuccess)(NSDictionary * _Nullable dicRes);
typedef void(^ _Nullable blockObjSuccess)(id _Nullable idRes);
typedef void(^ _Nullable blockError)(NSString *_Nullable errorRes);



@interface JUtils : NSObject

/**
 字符串转字典
 */
+ (NSDictionary *_Nonnull)dictionaryWithUrlString:(NSString *_Nonnull)urlStr;

/**
数组转字符串
*/
+ (NSString *_Nonnull)jsonStringWithPrettyPrint:(NSArray *_Nonnull)arr;
/**
 复杂字符串
 */
+ (void)copyString:(NSString *_Nonnull)string;

/**
 是否为全汉子
 */
+ (BOOL)isChinese:(NSString *_Nonnull)string;

/**
 钱包地址加隐私
 */
+ (NSString *_Nonnull)setWalletAddressNumber:(NSString *_Nonnull)number;

/**
 身份证加隐私
 */
+ (NSString *_Nonnull)setCardNumber:(NSString *_Nonnull)number;

/**
 名字加隐私
 */
+ (NSString *_Nonnull)setPrivacyName:(NSString *_Nonnull)name;

/**
 *text 文本
 *Placeholder 默认文本
 得到文本
 */
+ (NSString *_Nonnull)setLabelText:(NSString *_Nonnull)text withPlaceholder:(NSString *_Nonnull)holder;

/**
 得到颜色图片
 */
+ (UIImage *_Nonnull)createImageWithColor:(UIColor *_Nonnull)color;

/**
    是否全数字  YES :是全数字
*/
+ (BOOL)isAllNumber:(NSString *_Nonnull)str;



/// 是否是一个数字 （包含小数）
/// @param str 字串
+ (BOOL)isNumberContainsDecimal:(NSString *_Nonnull)str;
/**
    是否包含中文 YES :包含汉字
*/
+ (BOOL)isIncludeChinese:(NSString *_Nonnull)string;

/**
 意见反馈时获取客户端信息
 */
+ (NSString *)getPlatformInfo;


/**
 获取App发布版本信息
 */
+ (NSString *)getAppVersion;

//App Name
+ (NSString *)getAppName;

/**
 获取App BundleIdentifier
 */
+ (NSString *)getAppBundleIdentifier;

/**
 获取App Build版本信息
 */
+ (NSString *_Nonnull)getAppBuildVersion;

/**
 是否为电话号码
 patternStr 传入手机号
 */
+ (BOOL)isPhoneNumber:(NSString *_Nonnull)patternStr;

/**
 是否为淘口令
 patternStr 淘口令
 */
+ (BOOL)isTKLString:(NSString *_Nonnull)patternStr;

/**
 检测是否为邮箱
 patternStr 传入邮箱地址
 */
+ (BOOL)detectionIsEmailQualified:(NSString *_Nonnull)patternStr;

/**
 检测用户输入密码是否以字母开头，长度在8-18之间，只能包含字符、数字和下划线。
 patternStr 传入邮箱地址
 */
+ (BOOL)detectionIsPasswordQualified:(NSString *_Nonnull)patternStr;

/**
 *正则匹配用户密码6-20位数字和字母组合
 *数字+字母 且不小于8位
 */
+ (BOOL)checkAandStrPassword:(NSString *_Nonnull)password;


/**
 *正则匹配用户密码6-20位数字、字母、字符任意两种组合
 *数字+字母 且不小于8位
 */
+ (BOOL)checkTZLoginPassword:(NSString *_Nonnull)password;

/**
 验证身份证号（15位或18位数字）
 
 patternStr 传入身份证号
 
 */
+ (BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr;


/**
 验证码格式是否有效
 
 patternStr 传入验证码rn
 */
+ (BOOL)isValidVerifyCode:(NSString *)patternStr;


/**
 邀请码格式是否有效
 
 patternStr
 */
+ (BOOL)isValidInvatationCode:(NSString *_Nonnull)patternStr;


/**
 根据银行卡号获取银行名称
 
 cardNo 卡号
 银行名称
 */
+ (NSString *_Nonnull)bankNameWithCardNo:(NSString *_Nonnull)cardNo;


/**
 通过view获取一个image
 
 view
 
 */
+ (UIImage *_Nonnull)imageFromView:(UIView *_Nonnull)view;


/**
 创建一个缩略图
 
 image 原始图片
 scale 缩放后的尺寸
 */
+ (UIImage *_Nonnull)thumbnailWithImage:(UIImage *_Nonnull)image scale:(CGFloat)scale;



/**
 将图片资源转换为逻辑尺寸
 
 image 原始图片资源
 scale 缩放倍率 根据屏幕像素密度
 转换后的图片
 */
+ (UIImage *_Nonnull)convertToLogicSizeWithImage:(UIImage *_Nonnull)image screenScale:(CGFloat)scale;

/**
 身份证校验
 
 identityString 身份证
 */
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;



/**
 取图片名
 
 extName
 */
+(NSString*)MakeFileName:(NSString *)extName;


/**
 图片裁剪
 
 image
 newSize
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 计算字符串的Frame
 
 string
 width
 height
 fontSize
 */
+ (CGRect)getCalculateRectWithString:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFontSize:(CGFloat)fontSize;

/**
 字符数量计算
 
 text
 */
+(NSUInteger) unicodeLengthOfString: (NSString *) text;


/**
 获取当前时间
 
 spTime
 */
+(NSString *)getTimeString:(double )spTime;

/**
 根据格式将时间戳转为日期字符串
 
 timestamp
 format
 */
+(NSString*)stringFromTimestamp:(NSString*)timestamp dateFormat:(NSString *)format;

/**
 时间戳转换为日期
 
 timestamp
 */
+ (NSDate *)dateFromTimestamp:(NSString *)timestamp;
/**
 字母
 */
+ (NSString *)getFirstLetterFromString:(NSString *)aString;

/**
 获取当前时间
 */
+(NSString*)getCurrentTimes;

//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3;

/**
    获取 时间戳转换出来的date 到i秒
 */
+ (NSDate *)getDateWithSecondNumbertamp:(NSString *)timestamp;

//view  移动动画
+ (void)animationView:(UIView *)aView
                fromY:(float)fromY
                  toY:(float)toY
             duration:(float)durationTime;

+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                  toX:(float)toX
             duration:(float)durationTime;

+ (void)animationViewCenter:(UIView *)aView
                      fromX:(float)fromX
                        toX:(float)toX
                   duration:(float)durationTime;


/**
 获取本地视频第一针图片
 
 videoURL
 type 1 本地  2 服务器
 */
+(UIImage *)getThumbnailImage:(NSString *)videoURL type:(NSInteger )type;

/**
 判断是否为链接地址
 
 url
 */
+(NSURL *)isHttpWechatImg:(NSString *)url;

/**
 MD5加密小写
 
 string
 */
+ (NSString *)md5:(NSString *)string;

/**
 获取故事版
 
 sbname
 identifier
 */
+ (id)storyboardWithName:(NSString *)sbname Identifier:(NSString *)identifier;

/**
 获取当前控制器
 */
+ (UIViewController *)viewTopViewController;

+(UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController;


/**
 去除空key
 
 params
 */
+ (NSDictionary *)conversion:(NSDictionary *)params;

/**
 自定义系统提示
 (两个按钮)
 traget
 message
 title
 cancel
 done
 block
 */
+(void)alertTarget:(id)traget message:(NSString *)message title:(NSString *)title cancel:(NSString *)cancel done:(NSString *)done dBlcok:(void(^)(NSInteger index))block;

/**
 自定义系统提示
 (单个按钮)
 traget
 message
 title
 cancel
 done
 block
 */
+(void)alertTarget:(id)traget message:(NSString *)message title:(NSString *)title done:(NSString *)done dBlcok:(void(^)(NSInteger index))block;



/**
 MD5加密小写
 string
 */
+ (NSString *)MD5ForLower32Bate:(NSString *)str;

/**
 生成二维码
 带login
 */
+ (UIImage *)createQRCodeWithUrl:(NSString *)url centerImage:(NSString *)imgName;



/** 将CIImage转换成UIImage 并放大(内部转换使用)*/

+ (UIImage *)imageWithImageSize:(CGFloat)size withCIIImage:(CIImage *)ciiImage;


/**
 (普通)
 生成二维码
 QRStering:字符串
 imageFloat:二维码图片大小
 */
+ (UIImage *)createQRCodeWithString:(NSString *)QRStering withImgSize:(CGFloat)imageFloat;


/**
 (中间有小图片)
 生成二维码
 QRStering:字符串
 centerImage:二维码中间的image对象
 */
+ (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage;

// 字典转json字符串方法
+ (NSString *_Nonnull)convertToJsonData:(NSDictionary *)dict;

// JSON字符串转化为字典
+ (NSDictionary *_Nullable)dictionaryWithJsonString:(NSString *)jsonString;


//计算textfield控制代理结果字符串
+ (NSString *)resultStrOfTextFieldWithTextField:(UITextField *)textField range:(NSRange)range string:(NSString *)string;

///判断输入的是否是网址
+ (BOOL)isUrlAddress:(NSString*)url;

///判断是否为社会信用代码
+ (BOOL)isSocialCredit18Number:(NSString *)socialCreditNum;

///压缩图片
+ (UIImage *)compressImageWith:(UIImage *)image;


///设置带有图片的富文本
+ (NSMutableAttributedString *)setAttributedString:(NSString *)str withfont:(UIFont *)font withWidth:(CGFloat)width withtextColor:(UIColor *)color;

///计算html的高度
+ (NSInteger)hideLabelLayoutHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize;




///json字符串转数组
+ (NSArray *)stringToJSON:(NSString *)jsonStr;


#pragma mark ---- 将时间戳转换成时间 13位数
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp;

/**
    获取 时间戳转换出来的date
 */
+ (NSDate *)getDateWithTimestamp:(NSString *)timestamp;

#pragma mark ---- 将时间戳转换成时间------10位
+ (NSString *)getTimeFromTimeTen:(NSString *)timestamp;

#pragma mark ---- 将时间戳转换成时间------10位----几月几日
+ (NSString *)getStringTimeFromTimeTen:(NSString *)timestamp;

#pragma mark ---- 将时间戳转换成时间 有时分秒
+ (NSString *)getTimeFromTimestampHHMMSS:(NSString *)timestamp;

+ (NSString *)getTimeFromTimestampFromat:(NSString *)timestamp format:(NSString *)format;

#pragma mark ---- 将时间戳转换成时间--时分秒----13位
+ (NSString *)getTimeFromTimestampVehicle:(NSString *)timestamp;


+ (NSString *)getTimeFromTimestampHHMM:(NSString *)timestamp;

+ (NSString *)getTimeFromTimestampFarmat:(NSString *)timestamp separator:(NSString *)separator;



/**
  设置圆角
    UIRectCornerTopLeft
    UIRectCornerTopRight
    UIRectCornerBottomLeft
    UIRectCornerBottomRight
    UIRectCornerAllCorners
*/
+ (CAShapeLayer *)setCornerRadiusWithBezier:(CGRect)aRect byCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;


/***
    获取TextField 代理的最终字串
    textField ：字串
    string: 操作符
 */
+(NSString *)getStringTextFieldFormatWith:(NSString *)textField replacementString:(NSString *)string;


/**
/////  和当前时间比较
////   1）1分钟以内 显示        :    刚刚
////   2）1小时以内 显示        :    X分钟前
///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
///    4) 今年显示              :   09月12日
///    5) 大于本年      显示    :    2013/09/09
**/

#pragma mark -将时间戳直接转换为距现在的时间定义
+ (NSString *)formateDate:(NSString *)dateString;

#pragma mark -将时间戳直接转换为距现在的时间定义 13位数
+ (NSString *)showTimeFromTimestamp:(NSString *)timestamp;


///判断输入到TextField的内容是不是数字
+ (BOOL)validateNumber:(NSString*)number;

//匹配相应的字符串
+(NSArray *_Nonnull)RegulaString:(NSString *_Nonnull)String;


//金额的格式转化
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str;


//是否有小数点
+ (NSString *)hasDecimal:(NSString *)string;


/**
正则匹配
用户密码1-18位数字和字母组合
*/
+ (BOOL)checkPassword:(NSString*) password;


/**
获取ip地址
*/
+(NSString *_Nullable)getIPAddress;


#pragma mark 获取唯一uuID
+ (NSString *)uuidString;

//设备型号
+ (NSString *)deviceType;


/*
 金额展示优化
 要求保留最多两位小数，且四舍不入，若第二位小数为0则去掉，若两位小数都为0则只保留整数部分
 */

+ (NSString *)reviseDoubleValue:(double)price;



/*
 从字典取出NSNumber/NSString转换为NSDecimalNumber
 */
+ (NSDecimalNumber *)decimalNumberFromDict:(NSDictionary *)dict withKey:(NSString *)key;

/*
 转换commissionRate为标准的金额格式NSDecimalNumber
 */
+ (NSDecimalNumber *)decimalNumberWithCommissionRate:(NSString *)commissionRate;


//计算字符串的高度
+ (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width;


//计算字符串的宽度
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height;

///富文本加载html
+ (NSMutableAttributedString *)setAttributedString:(NSString *)str withfont:(UIFont *)font withWidth:(CGFloat)width;


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
+ (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font;

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
+ (CGFloat)getSpaceLabelHeightwithString:(NSString *)content withTextFontSize:(CGFloat)mFontSize withWidth:(CGFloat)width;

/**
*  随机获取数组里面的元素
*/
+(NSDictionary *)getRandomItem:(NSMutableArray *)arr;

//替换HTML中的格式 
+(NSString *)getHtmlStringFormatWithString:(NSString *_Nonnull)htmlString;

//HTML适配图片文字
+ (NSMutableString *_Nullable)adaptWebViewForHtml:(NSString *)htmlStr;


//数组转json字符串
+ (NSString *)pictureArrayToJSON:(NSArray *)picArr;

// 获取拼接_Nullable参数后的地址
//1、已过虑掉url中存在的key 2、已处理URL是否有参数的情况
+(NSString *)getURLBySplicingParam:(NSString *)url parm:(NSDictionary *)dic;


/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *  @param text 字符串
 *  @param size 填入预留的大小
 *  @param font 字体大小 *
 *  @return 返回CGRect
 */
+ (CGRect)stringWidthRectWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font;

/**
 * 从缓存中获取存入的变量，传递给小程序
 */
+ (NSMutableDictionary *)getAllPrefs;


//转mac地址
+ (NSString *)convertDataToHexStr:(NSData *)data;


/**
 设置蓝牙(开关)
*/
+ (void)setBluetoothDevices;

/**
 十六进制转换为数字   (转十进制)
 */
+ (NSString *_Nonnull)numberWithHexString:(NSString *_Nonnull)hexStrin;


/**
 整型转二进制字符串（00000000|00000000|00000000|00000001）
 */
+ (NSString *_Nonnull)intToBinaryString:(int)intValue;
/**
 整型转二进制字符串（00000000000000000000000000000001）
 */
+ (NSString *_Nonnull)intToBinary:(int)intValue;
/**
 base64加密
 */
+ (NSString *_Nonnull)base64encode:(NSString *_Nonnull)str;

// base64解码

+ (NSString *_Nonnull)base64Decode:(NSString *_Nonnull)str;

/**
 * AES加密
 */
+ (NSString *_Nonnull)encryptAESCBC:(NSString *_Nonnull)inputString;
 
/**
 * AES解密
 */
+ (NSString *_Nonnull)aesDecrypt:(NSString *_Nonnull)secretStr;
@end
