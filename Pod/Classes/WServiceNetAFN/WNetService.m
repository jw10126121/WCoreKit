//
//  WNetService.m
//
//  Created by Linjw on 16/7/25.
//  Copyright © 2016年 Linjw. All rights reserved.
//


#import "WNetService.h"

@interface WNetService ()



@end


@implementation WNetService

/**
 *   方法类型转化
 */
+(NSString *)wHttpMethodStrWithType:(HttpMethodType)type
{
    NSString * method = @"GET";
    switch (type)
    {
        case HttpMethodGet:
            method = @"GET";
            break;
        case HttpMethodPost:
            method = @"POST";
            break;
        case HttpMethodDelete:
            method = @"DELETE";
            break;
        case HttpMethodHead:
            method = @"HEAD";
            break;
        case HttpMethodOptions:
            method = @"OPTIONS";
            break;
        case HttpMethodPut:
            method = @"PUT";
            break;
        default:
            break;
    }
    return method;
}


@end







