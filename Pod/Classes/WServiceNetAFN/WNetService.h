//
//  WNetService.h
//
//  Created by Linjw on 16/7/25.
//  Copyright © 2016年 Linjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNetServiceDelegate.h"

/**
 *  网络请求基类
 */
@interface WNetService : NSObject <WNetServiceDelegate>


/**
 *   方法类型转化
 */
+ (NSString *)wHttpMethodStrWithType:(HttpMethodType)type;



@end






