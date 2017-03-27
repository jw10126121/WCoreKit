//
//  WNetServiceDelegate.h
//
//  Created by Linjw on 16/7/25.
//  Copyright © 2016年 Linjw. All rights reserved.
//

#import <Foundation/Foundation.h>

//HTTP请求方法
typedef NS_ENUM(NSInteger, HttpMethodType)
{
    HttpMethodPost,
    HttpMethodGet,
    HttpMethodDelete,
    HttpMethodHead,
    HttpMethodOptions,
    HttpMethodPut
};

typedef NS_ENUM(NSInteger, WHttpsMode)
{
    WHttpsModeNone,
    WHttpsModePublicKey,
    WHttpsModeCertificate,
    WHttpsModeNoHttps
};

@protocol WNetServiceDelegate <NSObject>



@optional

#pragma mark - 常用网络请求
/**
 *  网络请求类(基本数据请求),成功返回结果为Data
 *
 *  @param apiStr         URL
 *  @param paramsDic      参数
 *  @param headParamsDic  头部参数
 *  @param httMethod http方法类型
 *  @param ResultBlk      返回结果Block(state : 错误码)
 *
 *  @return 请求类
 */
- (id)wNetBase:(NSString *)apiStr
        Params:(NSDictionary *)paramsDic
    HeadParams:(NSDictionary *)headParamsDic
    HttpMethod:(HttpMethodType)httMethod
        Result:(void(^)(NSError * error,id request, NSData * responseData))ResultBlk;


/**
 *  网络请求类(基本数据请求),成功返回结果为JSON对象
 *
 *  @param apiStr         URL
 *  @param paramsDic      参数
 *  @param headParamsDic  头部参数
 *  @param httMethod http方法类型
 *  @param ResultBlk      返回结果Block(state : 错误码)
 *
 *  @return 请求类
 */
- (id)wNetJson:(NSString *)apiStr
        Params:(NSDictionary *)paramsDic
    HeadParams:(NSDictionary *)headParamsDic
    HttpMethod:(HttpMethodType)httpMethod
        Result:(void(^)(NSError * error,id request,id jsonObj,NSString * responseStr))ResultBlk;

/**
 *  网络请求类(基本数据请求),成功返回结果为JSON对象
 *
 *  @param apiStr         URL
 *  @param paramsDic      参数
 *  @param headParamsDic  头部参数
 *  @param typeHttpMethod http方法类型
 *  @param ResultBlk      返回结果Block(state : 错误码)
 *
 *  @return 请求类
 */
-(id)wNetJson:(NSString *)apiStr
 HttpsCerMode:(WHttpsMode)httpsMode
 HttpsCerData:(NSData *)httpsData
       Params:(NSDictionary *)paramsDic
   HeadParams:(NSDictionary *)headParamsDic
   HttpMethod:(HttpMethodType)typeHttpMethod
       Result:(void(^)(NSError * error,id request,id jsonObj,NSString * responseStr))ResultBlk;

/**
 *  网络请求类(基本数据请求),成功返回结果为JSON对象
 *
 *  @param apiStr         URL
 *  @param paramsDic      参数
 *  @param headParamsDic  头部参数
 *  @param httMethod http方法类型
 *  @param httpsMode https模式
 *  @param httpsData https证书数据
 *  @param ResultBlk      返回结果Block(state : 错误码)
 *
 *  @return 请求类
 */
- (id)wNetBase:(NSString *)apiStr
  HttpsCerMode:(WHttpsMode)httpsMode
  HttpsCerData:(NSData *)httpsData
        Params:(NSDictionary *)paramsDic
    HeadParams:(NSDictionary *)headParamsDic
    HttpMethod:(HttpMethodType)httpMethod
        Result:(void(^)(NSError * error,id request, NSData * responseData))ResultBlk;





@end




