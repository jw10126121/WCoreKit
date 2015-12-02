//
//  JwDefine.h
//  WFrameDemo
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//


//$(SRCROOT)/$(PRODUCT_NAME)/Other

#ifndef WTools_JwDefine_h
#define WTools_JwDefine_h

#import "JWTools.h"


/**
 //在项目的prefix.pch文件里加入下面一段代码，加入后，NSLog就只在Debug下有输出，Release下不输出了。
 #ifndef __OPTIMIZE__
 #define NSLog(...) NSLog(__VA_ARGS__)
 #else
 #define NSLog(...) {}
 #endif
 **/


//设置网络指示器开关
//#define WNetworkActivityIndicatorVisible(isVisible) [UIApplication sharedApplication].networkActivityIndicatorVisible = isVisible 
//#define WGetWeakSelf(toName,instance)   __weak typeof(&*instance)toName = instance    //设置弱引用
//#define WGetStrongSelf(toName,instance)   __strong typeof(&*instance)toName = instance //设置强引用
//加载与nibClass同名的nib文件
//#define WLoadBundleNibClass(nibClass) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass) owner:self options:nil] firstObject]

#define WStatusBarHeight    ([UIApplication sharedApplication].statusBarFrame.size.height)
#define Screen_AppShowFrame ([UIScreen mainScreen].applicationFrame)
//#define AppContentHeight    (IsIos7SystemLater?Screen_Height:Screen_AppShowFrame.size.height)


//------------系统默认控件--------------
#define SystemNavBar                                 self.navigationController.navigationBar
#define SystemTabBar                                 self.tabBarController.tabBar
#define SystemNavBarHeight                           self.navigationController.navigationBar.bounds.size.height
#define SystemTabBarHeight                           self.tabBarController.tabBar.bounds.size.height
#define SystemDefaultNavBarHeightWithStatueBarNum    (64.0f)
#define SystemDefaultNavBarHeightWithoutStatusBarNum (44.0f)
#define SystemDefaultTabBarHeightNum                 (49.0f)

////-----------------颜色-----------------
//#define WColorFromRGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define WColorFromRGB(r,g,b)     WColorFromRGBA(r,g,b,1.0)


//ARC And MRC
#define WSDKIsRunInARC (__has_feature(objc_arc))
#define WSDKIsRunInMRC (!__has_feature(objc_arc))
//SDK是否是IOS9以上
#define WSDKIsIOS9OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_9_0)
//SDK是否是IOS8以上
#define WSDKIsIOS8OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_8_0)
//SDK是否是IOS7以上
#define WSDKIsIOS7OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_7_0)
//SDK是否是IOS6以上
#define WSDKIsIOS6OrLater                        WSDKIsOrLaterFromVersionFlag(__IPHONE_6_0)
//SDK是否是sdkVersion之后,sdkVersion形如:__IPHONE_9_0
#define WSDKIsOrLaterFromVersionFlag(sdkVersion) (__IPHONE_OS_VERSION_MAX_ALLOWED >= sdkVersion)
//SDK是否是sdkVersion之前,sdkVersion形如:__IPHONE_9_0
#define WSDKBeforeFromVersionFlag(sdkVersion)    ((__IPHONE_OS_VERSION_MAX_ALLOWED < sdkVersion))

/*
 //是否是iPad
 #define WIsIPad          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 //是否是iPhone
 #define WIsIPhone        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//--------系统相关--------
//APP版本
#define WAppVersionStr [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//获取App名称
#define WAppBundleDisplayName [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]
//系统版本号
#define WIosVersionFloat                         ([[UIDevice currentDevice] systemVersion].floatValue)
//判断当前系统版本 == ver?
#define WIosVersion_EqualTo(ver)                 ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedSame)
//判断当前系统版本 > ver?
#define WIosVersion_MoreThan(ver)                ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedDescending)
//判断当前系统版本 >= ver?
#define WIosVersion_MoreThanOrEqualTO(ver)       ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] != NSOrderedAscending)
//判断当前系统版本 < ver?
#define WIosVersion_LessThan(ver)                ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedAscending)
//判断当前系统版本 <= ver?
#define WIosVersion_LessThanOrEqualTO(ver)       ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] != NSOrderedDescending)
//是否是IOS7系统以上
#define WIsIos7SystemLater                       (WIsOrLaterFromSystem(7.0))
#define WIsOrLaterFromSystem(sysVersion)         (WIosVersionFloat >= sysVersion)
*/


















#endif
