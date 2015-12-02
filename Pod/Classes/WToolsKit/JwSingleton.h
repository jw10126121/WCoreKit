//
//  JwSingleton.h
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#ifndef WTools_JwSingleton_h
#define WTools_JwSingleton_h

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





#endif



