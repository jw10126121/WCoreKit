//
//  JWTools.h
//  WTools
//
//  Created by linjiawei on 15/7/31.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -----------------单例-----------------
/*
 *   宏定义单例方法
 *   使用时，在要设置单例的类Interface里面，调用  wSingleton_SharedInstance()
 *          在要设置单例的类Implementation里面，运行   wSingleton_Implementation(className)
 *          调用时，如果要生成对象，类的SharedInstance方法
 */

#define wSingleton_Interface(aClassName) +(aClassName *)sharedInstance
#define wSingleton_SharedInstance(aClassName) wSingleton_Interface(aClassName)

#define wSingleton_Implementation(className) \
\
+ (instancetype)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


//#define WGetKeyWindow [UIApplication sharedApplication].keyWindow  //获取KeyWindow
//#define WKeyWindowEndEditing [[UIApplication sharedApplication].keyWindow endEditing:YES]  //隐藏键盘

//设置网络指示器开关
#define WNetworkActivityIndicatorVisible(isVisible) \
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isVisible
#define WGetWeakSelf(toName,instance)   __weak typeof(&*instance)toName = instance    //设置弱引用
#define WGetStrongSelf(toName,instance)   __strong typeof(&*instance)toName = instance //设置强引用
//加载与nibClass同名的nib文件
#define WLoadBundleNibClass(nibClass) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass) owner:self options:nil] firstObject]
#define WScreenWidth wScreenSize().width
#define WScreenHeight wScreenSize().height

@interface JWTools : NSObject

#pragma mark - 系统相关与设备

/**
 *  注册远程推送
 */
void wRegisterForRemoteNotification(UIApplication * application);

/**
 *  当前系统版本号
 */
CGFloat wCurrentSystemVersionStr();

/**
 *  系统版本号是否为verStr (即: = verStr)
 */
BOOL wIsSystemVersionEqualTo(NSString * verStr);

/**
 *  系统版本号是否超过verStr (即: > verStr)
 */
BOOL wIsSystemVersionGreater(NSString * verStr);

/**
 *  系统版本号是否不小于verStr (即: >= verStr)
 */
BOOL wIsSystemVersionEqualOrGreater(NSString * verStr);

/**
 *  系统版本号是否小于verStr (即: < verStr)
 */
BOOL wIsSystemVersionLesserThan(NSString * verStr);

/**
 *  系统版本号是否不大于verStr (即: <= verStr)
 */
BOOL wIsSystemVersionEqualOrLesserThan(NSString * verStr);

/**
 *  屏幕宽高
 */
CGSize wScreenSize();

/**
 *  获取KeyWindow
 */
UIWindow * wGetKeyWindow();

/**
 *  使APP中的键盘编辑状态关闭(即：键盘隐藏)
 */
void wKeyWindowEndEditing();

/**
 *  设备是否为iPhone
 */
BOOL wIsIPhoneDevice();

/**
 *  设备是否为iPad
 */
BOOL wIsIPadDevice();

/**
 *  获取启动图 (使用前请确保已设置xcassets中Brand Assets或者LaunchImage)
 *  如果要获取当前屏幕的启动图，isPortrait = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)
 */
UIImage * wGetLaunchImage(BOOL isPortrait);

#pragma mark - 工程信息

/**
 *  获取App设置信息
 */
NSDictionary * wGetAppConfigSettings();

/**
 *  获取工程BundleId
 */
NSString * wBundleId(void);

/**
 *  获取工程版本号
 */
NSString * wBundleVersion(void);

/**
 *  获取App版本
 */
NSString * wAppVersion(void);

/**
 *  获取App显示名称
 */
NSString * wAppBundleDisplayName(void);

/**
 *  获取uuid
 */
NSString * wUUID(void);

#pragma mark - NSDate

/**
 *  当前时间转字符串
 */
NSString * wCurrentDateStrWithFormatterStr(NSString * formatterStr);

/**
 *  字符串转时间对象
 */
NSDate * wDateWithDateStr(NSString * dateStr,NSString * formatterStr);

#pragma mark - 字符串 NSString

/**
 *  生成MD5加密字符串
 */
NSString * wMd5Str(NSString * string);

#pragma mark - 路径相关

/**
 *  拼接URL
 */
NSString * wApiWithParams(NSString * domain,NSDictionary * params);

/**
 *  拼接URL
 */
NSString * wApiGetFullURL(NSString * aApiDomain,NSString * path);












@end












