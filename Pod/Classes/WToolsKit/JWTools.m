//
//  JWTools.m
//  WTools
//
//  Created by linjiawei on 15/7/31.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "JWTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>


@interface JWTools ()

@end

@implementation JWTools

#pragma mark - 系统相关

/**
 *  注册远程推送
 */
void wRegisterForRemoteNotification(UIApplication * application)
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound| UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound| UIRemoteNotificationTypeAlert;
        [application registerForRemoteNotificationTypes:myTypes];
#pragma clang diagnostic pop
    }
}

/**
 *  当前系统版本号
 */
CGFloat wCurrentSystemVersionStr()
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    return systemVersion;
}

/**
 *  系统版本号是否为verStr (即: = verStr)
 */
BOOL wIsSystemVersionEqualTo(NSString * verStr)
{
    return ([[[UIDevice currentDevice] systemVersion] compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

/**
 *  系统版本号是否超过verStr (即: > verStr)
 */
BOOL wIsSystemVersionGreater(NSString * verStr)
{
    return ([[[UIDevice currentDevice] systemVersion] compare:verStr options:NSNumericSearch] == NSOrderedDescending);
}

/**
 *  系统版本号是否不小于verStr (即: >= verStr)
 */
BOOL wIsSystemVersionEqualOrGreater(NSString * verStr)
{
    return ([[[UIDevice currentDevice] systemVersion] compare:verStr options:NSNumericSearch] != NSOrderedAscending);
}

/**
 *  系统版本号是否小于verStr (即: < verStr)
 */
BOOL wIsSystemVersionLesserThan(NSString * verStr)
{
    return ([[[UIDevice currentDevice] systemVersion] compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

/**
 *  系统版本号是否不大于verStr (即: <= verStr)
 */
BOOL wIsSystemVersionEqualOrLesserThan(NSString * verStr)
{
    return ([[[UIDevice currentDevice] systemVersion] compare:verStr options:NSNumericSearch] != NSOrderedDescending);
}

/**
 *  屏幕宽高
 */
CGSize wScreenSize()  //屏幕宽高(相对于当前屏幕旋转方式)
{
    CGSize theSize = [UIScreen mainScreen].bounds.size;
    if (!UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) || [[UIDevice currentDevice] systemVersion].floatValue >= 8.0)
    {
        theSize = (CGSize){[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height};
    }else
    {
        theSize = (CGSize){[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width};
    }
    return theSize;
}

/**
 *  获取KeyWindow
 */
UIWindow * wGetKeyWindow()
{
    return [UIApplication sharedApplication].keyWindow;
}

/**
 *  使APP中的键盘编辑状态关闭(即：键盘隐藏)
 */
void wKeyWindowEndEditing()
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/**
 *  设备是否为iPhone
 */
BOOL wIsIPhoneDevice()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

/**
 *  设备是否为iPad
 */
BOOL wIsIPadDevice()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

/**
 *  获取启动图,
 *  如果要获取当前屏幕的启动图，isPortrait = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)
 */
UIImage * wGetLaunchImage(BOOL isPortrait)
{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    NSString *viewOrientation = isPortrait ? @"Portrait" : @"Landscape";
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

#pragma mark - 工程信息

/**
 *  获取App设置信息
 */
NSDictionary * wGetAppConfigSettings()
{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]];
}

/**
 *  获取工程BundleId
 */
NSString * wBundleId(void)
{
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return identifier;
}

NSString * wBundleVersion(void)
{
    
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

/**
 *  获取App版本
 */
NSString * wAppVersion(void)
{
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

/**
 *  获取App显示名称
 */
NSString * wAppBundleDisplayName(void)
{
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]];
}

/**
 *  获取uuid
 */
NSString * wUUID(void)
{
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref= CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge_transfer NSString*)uuid_string_ref];
    return uuid;
}

#pragma mark - NSDate

/**
 *  当前时间转字符串
 */
NSString * wCurrentDateStrWithFormatterStr(NSString * formatterStr)
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatterStr];
    return [dateFormat stringFromDate:[NSDate date]];
}

/**
 *  字符串转时间对象
 */
NSDate * wDateWithDateStr(NSString * dateStr,NSString * formatterStr)
{
    if (dateStr.length <= 0 || formatterStr.length <= 0)
    {
        return nil;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatterStr];
    return [dateFormat dateFromString:dateStr];
}

#pragma mark - 字符串 NSString

/**
 *  生成MD5加密字符串
 */
NSString * wMd5Str(NSString * str)
{
    if (!str) return nil;
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

#pragma mark - 路径相关

/**
 *  拼接URL
 */
NSString * wApiWithParams(NSString * domain,NSDictionary * params)
{
    NSMutableString * theStr = nil;
    if (!domain) {  return nil; }
    theStr = [domain mutableCopy];
    BOOL hasParams = ([domain rangeOfString:@"?"].location != NSNotFound);
    if (!hasParams)
    {
        if ([theStr hasSuffix:@"/"] )
        {
            NSRange range = [theStr rangeOfString:@"/" options:NSBackwardsSearch];
            if (range.location != NSNotFound)
            {
                theStr = [[theStr stringByReplacingCharactersInRange:range withString:@""] mutableCopy];
            }
        }
        [theStr appendFormat:@"?"];
    }
    
    if (params.count)
    {
        if (hasParams) {
            [theStr appendFormat:@"&"];
        }
        for (NSString * key in params)
        {
            [theStr appendFormat:@"%@=",key];
            [theStr appendFormat:@"%@",params[key]];
            [theStr appendFormat:@"&"];
        }
    }
    
    if ([theStr hasSuffix:@"&"] )
    {
        NSRange range = [theStr rangeOfString:@"&" options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            theStr = [[theStr stringByReplacingCharactersInRange:range withString:@""] mutableCopy];
        }
    }
    
    return theStr;
}

/**
 *  拼接URL
 */
NSString * wApiGetFullURL(NSString * aApiDomain,NSString * path)
{
    NSString * theApiDomain = [aApiDomain hasSuffix:@"/"] ? [aApiDomain substringToIndex:aApiDomain.length - 1] : aApiDomain;
    if ([path hasPrefix:theApiDomain])
    {
        return path;
    }
    NSString * headStr = [path hasPrefix:theApiDomain]?@"":theApiDomain;  //apiDomain
    NSString * midStr = [path hasPrefix:@"/"] ? @"" : @"/";
    NSString * footStr = path;
    NSString * url = [NSString stringWithFormat:@"%@%@%@",headStr,midStr,footStr];
    return url;
}

#pragma mark - 控件相关











@end










