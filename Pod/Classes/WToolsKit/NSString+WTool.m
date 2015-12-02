//
//  NSString+WTool.m
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "NSString+WTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>



@implementation NSString (WTool)

+ (NSString *)wStrShaFromStrNormal:(NSString *)str {
    if (!str) {
        return nil;
    }
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)wStrShaFromSelf
{
    return  [[self class] wStrShaFromStrNormal:self];
}

+(NSString *)wStrHexFromStrNormal:(NSString *)strNormal
{
    NSData * dataStr = [strNormal dataUsingEncoding:NSUTF8StringEncoding];
    NSString * strHex = [[self class] wStrHexFromData:dataStr];
    return strHex;
}
- (NSString *) wStrHexFromSelf{
    return [[self class] wStrHexFromStrNormal:self];
}

+(NSString *)wStrNormalFromStrHex:(NSString *)strHex
{
    NSData * data = [[self class] wDataFromStrHex:strHex];
#if !__has_feature(objc_arc)//如果是MRC
    return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
#else
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
#endif
}

- (NSString *) wStrNormalFromSelf{
    return [[self class] wStrNormalFromStrHex:self];
}

+(NSString *)wStrHexFromData:(NSData *)data
{
    NSString *str = @"0123456789ABCDEF";
    
    NSMutableString *retStr = [NSMutableString string];
    const Byte *bs = [data bytes];
    int bit;
    for (int i = 0; i < data.length; i++) {
        bit = (bs[i] & 0x0f0) >> 4;
        [retStr appendString:[str substringWithRange:NSMakeRange(bit, 1)]];
        bit = bs[i] & 0x0f;
        [retStr appendString:[str substringWithRange:NSMakeRange(bit, 1)]];
    }
    return retStr;
}

+(NSData *)wDataFromStrHex:(NSString *)strHex
{
    NSString *str = @"0123456789ABCDEF";
    strHex = [strHex uppercaseString];
    Byte *bytes = (Byte *)[[NSMutableData dataWithCapacity:strHex.length/2]bytes];
    NSUInteger n;
    for (int i = 0; i < strHex.length/2; i++) {
        n = [str rangeOfString:[strHex substringWithRange:NSMakeRange(2*i, 1)]].location << 4;
        n += [str rangeOfString:[strHex substringWithRange:NSMakeRange(2*i+1, 1)]].location;
        bytes[i] = (Byte) (n & 0xff);
    }
    return [NSData dataWithBytes:bytes length:strHex.length/2];
}

- (NSData *) wDataFromSelf{
    return [[self class] wDataFromStrHex:self];
}


+(NSString *)wStrMd5HexFromStrNormal:(NSString *)strNormal
{
    if (strNormal == nil)
    {
        return nil;
    }
    
    const char* str = [strNormal UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    return ret;
}


- (NSString *) wStrMd5HexFromSelf{
    return [[self class] wStrMd5HexFromStrNormal:self];
}



//DES解密
+(NSString *)wStrNormalFromStrDes:(NSString *)strDes DESKey:(NSString *)desKey
{
    NSString * cleartext = nil;
    NSData *textData = [self wDataFromStrHex:strDes];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [desKey UTF8String], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]  , [textData length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    
#if ! __has_feature(objc_arc)
    return [cleartext autorelease];
#else
    return cleartext;
#endif
}

- (NSString *)wStrNormalFromSelfWithDesKey:(NSString *)desKey{
    return [[self class] wStrNormalFromStrDes:self DESKey:desKey];
}

//DES加密
+(NSString *)wStrDesFromStrNormal:(NSString *)strNormal DESKey:(NSString *)desKey
{
    NSString *ciphertext = nil;
    NSData *textData = [strNormal dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [desKey UTF8String], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]  , [textData length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self wStrHexFromData:data];
    }else
    {
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}
- (NSString *)wStrDesFromSelfWithDesKey:(NSString *)desKey{
    return [[self class] wStrDesFromStrNormal:self DESKey:desKey];
}

- (NSString *)wTrim
{
    NSString *afterTrimString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return afterTrimString;
}

/**
 *   新浪微博文字计算方法
 *   中文状态下，每个汉字和符号都算一个字，在英文状态下，字母和符号都算半个字。
 *   当用NSUTF8StringEncoding来编码时，中文和中文状态下的字符都会是三个字节，英文状态下是1个字节，最后向下取整。
 *   http://blog.csdn.net/kay_sprint/article/details/7481129
 */
- (CGFloat)wTextLength
{
    float sum = 0.0;
    for (NSUInteger i = 0; i < [self length]; i++)
    {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            sum++;
        }
        else
        {
            sum += 0.5;
        }
    }
    return ceil(sum);
}

/**
 *  得到文本占用的大小
 *
 *  @param maxSize 最大的size
 *  @param font    字体
 *
 *  @return 文本占用的大小
 */
-(CGSize)wAutoSizeWithMaxSize:(CGSize)maxSize Font:(UIFont *)font
{
    return [self wAutoSizeWithMaxSize:maxSize Font:font SizeOffset:CGSizeZero];
}

/*!
 *  得到文本占用的大小
 *
 *  @param maxSize 最大的size
 *  @param font    字体
 *  @param offsetSize 宽高偏移
 *
 *  @return 占用的大小
 */
-(CGSize)wAutoSizeWithMaxSize:(CGSize)maxSize Font:(UIFont *)font SizeOffset:(CGSize)offsetSize
{
    CGSize autoSize = CGSizeZero;
    NSMutableDictionary * tdic =  [[NSMutableDictionary alloc]init];
    if (font) {
        tdic[NSFontAttributeName] = font;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (ios7_Or_Later)
    {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        tdic[NSParagraphStyleAttributeName] = paragraphStyle.copy;
        autoSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        /*
         autoSize = [self boundingRectWithSize:maxSize
         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
         attributes:tdic
         context:nil].size;
         */
        
        
    }else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        autoSize = [self sizeWithFont:font
                    constrainedToSize:maxSize
                        lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
#else
    autoSize = [self sizeWithFont:font
                constrainedToSize:maxSize
                    lineBreakMode:NSLineBreakByWordWrapping];
#endif
    CGSize resultSize = CGSizeMake(ceil(autoSize.width) + offsetSize.width, ceil(autoSize.height) + offsetSize.height);
    return resultSize;
}

#pragma mark - 正则

//是否匹配
+ (BOOL) wIsMatchStr:(NSString *)aStr RegularStr:(NSString *)regularStr{
    if (!aStr) {
        return NO;
    }
    //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    //    BOOL isMatch = [pred evaluateWithObject:aStr];
    //    return isMatch;
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:regularStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:aStr
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, aStr.length)];
#if ! __has_feature(objc_arc)
    [regularexpression release];
#endif
    return (numberofMatch > 0);
    
}

//是否匹配
- (BOOL) wIsMatchWithRegularStr:(NSString *)regularStr
{
    if (!regularStr) {
        return NO;
    }
    //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    //    BOOL isMatch = [pred evaluateWithObject:self];
    //    return isMatch;
    /*
     NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
     initWithPattern:regularStr
     options:NSRegularExpressionCaseInsensitive
     error:nil];
     NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:self
     options:NSMatchingReportProgress
     range:NSMakeRange(0, self.length)];
     #if ! __has_feature(objc_arc)
     [regularexpression release];
     #endif
     return (numberofMatch > 0);
     */
    
    return [[self class] wIsMatchStr:self RegularStr:regularStr];
    
}

//只含有charsString中的字符
-(BOOL)wIsMatchOnlyOtherChars:(NSString *)charsString
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:charsString] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

//是否包含中文
- (BOOL) wIsContainsChineseStr{
    if (!self)
    {
        return false;
    }
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return true;
    }
    return false;
}

- (BOOL) wIsMatchPhoneNumberStr{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_PhoneNumberStr];
    return [self wIsMatchWithRegularStr:RegularStr_PhoneNumberStr];
}


- (BOOL) wIsMatchEmailStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_EmailStr];
    return [self wIsMatchWithRegularStr:RegularStr_EmailStr];
}

//匹配身份证
- (BOOL) wIsMatchIdCardStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_IdCardStr];
    return [self wIsMatchWithRegularStr:RegularStr_IdCardStr];
}

//是否匹配QQ号码
-(BOOL) wIsMatchQQNumberStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_QQNumber];
    return [self wIsMatchWithRegularStr:RegularStr_QQNumber];
}



//是否匹配手机号码
-(BOOL) wIsMatchMobileNumberStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_MobileNumber];
    return [self wIsMatchWithRegularStr:RegularStr_MobileNumber];
}

//是否匹配中国移动手机号码
- (BOOL) wIsMatchMobileNumForChinaMobileStr
{
    return [self wIsMatchWithRegularStr:RegularStr_MobileNumberForChinaMobile];
}
//是否匹配中国联通手机号码
- (BOOL) wIsMatchMobileNumForChinaUnicomStr
{
    return [self wIsMatchWithRegularStr:RegularStr_MobileNumberForChinaUnicom];
}
//是否匹配中国电信手机号码
- (BOOL) wIsMatchMobileNumForChinaTelecomStr
{
    return [self wIsMatchWithRegularStr:RegularStr_MobileNumberForChinaTelecom];
}
//是否匹配陆地区固话及小灵通号码
- (BOOL) wIsMatchFixedTelephoneNumberStr
{
    return [self wIsMatchWithRegularStr:RegularStr_FixedTelephoneNumber];
}
//是否匹配邮政编码(中国邮政编码 6位数字)
-(BOOL) wIsMatchZipCodeStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_ZipCode];
    return [self wIsMatchWithRegularStr:RegularStr_ZipCode];
}
//是否匹配IP地址
-(BOOL) wIsMatchIpAddressStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_IpAddress];
    return [self wIsMatchWithRegularStr:RegularStr_IpAddress];
}
//匹配网址http://www.baidu.com/
-(BOOL) wIsMatchWebsiteStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_Website];
    return [self wIsMatchWithRegularStr:RegularStr_Website];
}
//匹配日期 YYYY-MM-DD YYYY/MM/DD YYYY_MM_DD YYYY.MM.DD
-(BOOL) wIsMatchDateStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_Date];
    return [self wIsMatchWithRegularStr:RegularStr_Date];
}

//是否包含给定的子字符串
-(BOOL)wIsMatchHadSubStr:(NSString *)subStr{
    if (!subStr) {
        return NO;
    }
    NSRange range = [self rangeOfString:subStr];
    BOOL isMatch = NO;
    if (range.length) {
        isMatch = YES;
    }
    return isMatch;
}

//判断是否以给定字符串结尾
-(BOOL)wIsMatchEndSubStr:(NSString *)endStr
{
    return ([self hasSuffix:endStr]) ? YES : NO;
}

//判断是否以给定字符串开头
-(BOOL)wIsMatchBeginSubStr:(NSString *)beginStr
{
    return ([self hasPrefix:beginStr]) ? YES : NO;
}

//是否在数组中
-(BOOL)wIsMatchInArray:(NSArray *)array
{
    for(NSString *string in array) {
        if([self isEqualToString:string])
        {
            return YES;
        }
    }
    return NO;
}

//加字符串
-(NSString *)wAddAString:(NSString *)aString
{
    if(!aString || aString.length == 0)
        return self;
    
    return [self stringByAppendingString:aString];
}

-(NSString *)wRemoveSubString:(NSString *)subString
{
        NSRange range = [self rangeOfString:subString];
        if (range.location != NSNotFound)
        {
            return  [self stringByReplacingCharactersInRange:range withString:@""];
        }else
        {
            return self;
        }
}

//只有字母
- (BOOL)wIsMatchOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

//只有大写字母
- (BOOL)wIsMatchOnlyUppercaseLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet uppercaseLetterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

//只有小写字母
- (BOOL)wIsMatchOnlyLowercaseLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet lowercaseLetterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

//只有数字
- (BOOL)wIsMatchOnlyNumbers
{
    return [self wIsMatchOnlyOtherChars:@"0123456789"];
}

//是否存在数字
-(BOOL) wIsMatchHadNumberStr
{
    //    return [[self class] wIsMatchStr:self RegularStr:RegularStr_HadNumberStr];
    return [self wIsMatchWithRegularStr:RegularStr_HadNumberStr];
}

//只有数字和字母
- (BOOL)wIsMatchOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}


//切分成数组
-(NSArray *)wArrayWithSeparatedStr:(NSString *)subStr
{
    return [self componentsSeparatedByString:subStr.length?subStr:@""];
}

//转成NSData
-(NSData *)wConvertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

//子字符串
-(NSString *)wSubStrFrom:(NSInteger)begin To:(NSInteger)end
{
    if (end == begin)
    {
        return nil;
    }
    NSRange r;
    r.location = MIN(begin, end);
    r.length = MAX(begin, end) - MIN(begin, end);
    return [self substringWithRange:r];
}





@end






