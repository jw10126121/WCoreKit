//
//  NSString+WTool.h
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//



//电话号码
#define RegularStr_PhoneNumberStr @"^((\\d{3,4})|\\d{3,4}-)?\\d{7,8}$"
//包含中文
#define RegularStr_HadChineseStr @"[\u4e00-\u9fa5]"
//电子邮箱
#define RegularStr_EmailStr @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*$"
//身份证
#define RegularStr_IdCardStr @"^\\d{17}[0-9X]$"

//存在数字
#define RegularStr_HadNumberStr @"[0-9]"
//QQ号码
#define RegularStr_QQNumber @"[1-9][0-9]{4,}"
//邮编
#define RegularStr_ZipCode @"^[1-9]\\d{5}$"
//IP地址
#define RegularStr_IpAddress @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)"
//网址
#define RegularStr_Website @"[a-zA-z]+://[^\\s]*"
//日期
#define RegularStr_Date @"((^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(10|12|0?[13578])([-\\/\\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(11|0?[469])([-\\/\\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(0?2)([-\\/\\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([3579][26]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$))"
//手机号码
/**
 * 手机号码: @"^1(2[0-9]|3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 * 联通：130,131,132,152,155,156,185,186
 * 电信：133,1349,153,180,189
 */
#define RegularStr_MobileNumber @"^1(2[0-9]|3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"//@"^[1][358]\\d{9}$"
//中国移动：China Mobile(134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188)
#define RegularStr_MobileNumberForChinaMobile @"^1(2[0-9]|3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//中国联通：China Unicom (130,131,132,152,155,156,185,186)
#define RegularStr_MobileNumberForChinaUnicom @"^1(3[0-2]|5[256]|8[56])\\d{8}$"
//中国电信：China Telecom (133,1349,153,180,189)
#define RegularStr_MobileNumberForChinaTelecom @"^1((33|53|8[09])[0-9]|349)\\d{7}$"
//大陆地区固话及小灵通(区号：010,020,021,022,023,024,025,027,028,029,号码：七位或八位)
#define RegularStr_FixedTelephoneNumber @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$"


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  字符串拓展
 */
@interface NSString (WTool)

//SHA
+ (NSString *)wStrShaFromStrNormal:(NSString *)str;
- (NSString *)wStrShaFromSelf;

//HEX
+ (NSString *) wStrHexFromStrNormal:(NSString *)strNormal;
- (NSString *) wStrHexFromSelf;
+ (NSString *) wStrNormalFromStrHex:(NSString *)strHex;
- (NSString *) wStrNormalFromSelf;
+ (NSString *) wStrHexFromData:(NSData *)data;
+ (NSData *) wDataFromStrHex:(NSString *)strHex;
- (NSData *) wDataFromSelf;

//MD5
+ (NSString *) wStrMd5HexFromStrNormal:(NSString *)strNormal;
- (NSString *) wStrMd5HexFromSelf;

//DES解密
+ (NSString *)wStrNormalFromStrDes:(NSString *)strDes DESKey:(NSString *)desKey;
- (NSString *)wStrNormalFromSelfWithDesKey:(NSString *)desKey;

//DES加密
+ (NSString *)wStrDesFromStrNormal:(NSString *)strNormal DESKey:(NSString *)desKey;
- (NSString *)wStrDesFromSelfWithDesKey:(NSString *)desKey;

//去掉空格
- (NSString *)wTrim;

/**
 *   新浪微博文字计算方法
 *   中文状态下，每个汉字和符号都算一个字，在英文状态下，字母和符号都算半个字。
 *   当用NSUTF8StringEncoding来编码时，中文和中文状态下的字符都会是三个字节，英文状态下是1个字节，最后向下取整。
 *   http://blog.csdn.net/kay_sprint/article/details/7481129
 */
- (CGFloat)wTextLength;


/**
 *  得到文本占用的大小
 *  @param maxSize 最大的size
 *  @param font    字体
 *  @return 文本占用的大小
 */
- (CGSize)wAutoSizeWithMaxSize:(CGSize)maxSize Font:(UIFont *)font;

/*!
 *  得到文本占用的大小
 *  @param maxSize 最大的size
 *  @param font    字体
 *  @param offsetSize 宽高偏移
 *  @return 占用的大小
 */
-(CGSize)wAutoSizeWithMaxSize:(CGSize)maxSize Font:(UIFont *)font SizeOffset:(CGSize)offsetSize;

#pragma mark - 正则

//是否匹配
+ (BOOL) wIsMatchStr:(NSString *)aStr RegularStr:(NSString *)regularStr;
//是否匹配
- (BOOL) wIsMatchWithRegularStr:(NSString *)regularStr;

//只含有charsString中的字符
-(BOOL)wIsMatchOnlyOtherChars:(NSString *)charsString;

//只有字母，不区分大小写
- (BOOL)wIsMatchOnlyLetters;
//只有大写字母
- (BOOL)wIsMatchOnlyUppercaseLetters;
//只有小写字母
- (BOOL)wIsMatchOnlyLowercaseLetters;

//只有数字
- (BOOL)wIsMatchOnlyNumbers;
//是否存在数字
- (BOOL) wIsMatchHadNumberStr;

//只有数字或字母
- (BOOL)wIsMatchOnlyNumbersAndLetters;

//判断字符串中是否包含中文
- (BOOL) wIsContainsChineseStr;

//匹配电话号码(“XXXX-XXXXXXX”，“XXXX-XXXXXXXX”，“XXX-XXXXXXX”，“XXX-XXXXXXXX”，“XXXXXXX”，“XXXXXXXX”)
- (BOOL) wIsMatchPhoneNumberStr;

//匹配Email
- (BOOL) wIsMatchEmailStr;

//匹配身份证
- (BOOL) wIsMatchIdCardStr;

//是否匹配QQ号码(QQ号从10000开始)
- (BOOL) wIsMatchQQNumberStr;

//是否匹配手机号码(中国电信、中国移动、中国联通)
- (BOOL) wIsMatchMobileNumberStr;

//是否匹配中国移动手机号码
- (BOOL) wIsMatchMobileNumForChinaMobileStr;

//是否匹配中国联通手机号码
- (BOOL) wIsMatchMobileNumForChinaUnicomStr;

//是否匹配中国电信手机号码
- (BOOL) wIsMatchMobileNumForChinaTelecomStr;

//是否匹配陆地区固话及小灵通号码
- (BOOL) wIsMatchFixedTelephoneNumberStr;

//是否匹配邮政编码(中国邮政编码 6位数字)
- (BOOL) wIsMatchZipCodeStr;

//是否匹配IP地址
- (BOOL) wIsMatchIpAddressStr;

//匹配网址 http://www.baidu.com/
- (BOOL) wIsMatchWebsiteStr;

//匹配日期 YYYY-MM-DD YYYY/MM/DD YYYY_MM_DD YYYY.MM.DD
- (BOOL) wIsMatchDateStr;

//是否包含给定的子字符串
- (BOOL)wIsMatchHadSubStr:(NSString *)subStr;

//判断是否以给定字符串结尾
-(BOOL)wIsMatchEndSubStr:(NSString *)endStr;

//判断是否以给定字符串开头
-(BOOL)wIsMatchBeginSubStr:(NSString *)beginStr;

//是否在数组中
-(BOOL)wIsMatchInArray:(NSArray *)array;

#pragma mark - 字符串操作

//加字符串
-(NSString *)wAddAString:(NSString *)aString;

//移除字符串
-(NSString *)wRemoveSubString:(NSString *)subString;

//切分成数组
-(NSArray *)wArrayWithSeparatedStr:(NSString *)subStr;

//转成NSData
-(NSData *)wConvertToData;

//子字符串
-(NSString *)wSubStrFrom:(NSInteger)begin To:(NSInteger)end;


@end
