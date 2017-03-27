//
//  WServiceNetAFN.m
//
//  Created by Linjw on 16/7/25.
//  Copyright © 2016年 Linjw. All rights reserved.
//


#import "WServiceNetAFN.h"
#import <WCoreKit/WJsonTool.h>
#import <WCoreKit/WTools.h>
#import <WCoreKit/JWTools.h>

NSString *const UserDefaultCookieKey      = @"__UserDefaultCookieKey__";


@interface WServiceNetAFN ()

@property(nonatomic,strong)AFHTTPSessionManager * manage;


@end


@implementation WServiceNetAFN

- (instancetype)init
{
    self = [super init];
    if (self) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        self.manage = manager;
    }
    return self;
}


- (id)wNetBase:(NSString *)apiStr
  HttpsCerMode:(WHttpsMode)httpsMode
  HttpsCerData:(NSData *)httpsData
        Params:(NSDictionary *)paramsDic
    HeadParams:(NSDictionary *)headParamsDic
    HttpMethod:(HttpMethodType)httpMethod
        Result:(void(^)(NSError * error,id request, NSData * responseData))ResultBlk
{
    apiStr = [apiStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager * manager = self.manage;//[AFHTTPSessionManager manager];
    //    if (!apiStr.length)
    //    {
    //        NSLog(@"NetError:%@",@"apiStr不存在");
    //        ResultBlk(404,nil,nil);
    //        return nil;
    //    }
    
    switch (httpMethod) {
        case WHttpsModeNoHttps:
            
            break;
        case WHttpsModeNone:
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.securityPolicy.allowInvalidCertificates = YES;
            [manager.securityPolicy setValidatesDomainName:NO];
            break;
        case WHttpsModeCertificate:
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            manager.securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:httpsData, nil];
            manager.securityPolicy.allowInvalidCertificates = YES;
            [manager.securityPolicy setValidatesDomainName:NO];
            break;
        default:
            break;
    }

    
    NSString * mothodStr = [[self class] wHttpMethodStrWithType:httpMethod];
    
    NSMutableURLRequest * request = nil;
    
    
    NSMutableDictionary * files = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * theParams = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * initParams = [[NSMutableDictionary alloc] initWithDictionary:paramsDic];
    
    for (NSString * key in initParams) {
        if ([paramsDic[key] isKindOfClass:[NSData class]])
        {
            files[key] = initParams[key];
        }else if ([paramsDic[key] isKindOfClass:[UIImage class]])
        {
            NSData * data = UIImageJPEGRepresentation(paramsDic[key], 0.8);
            files[key] = data;
        }else
        {
            theParams[key] = initParams[key];
        }
    }
    //新建request时的超时时间
    manager.requestSerializer.timeoutInterval = 10;
    if (httpMethod == HttpMethodPost) {
        request = [manager.requestSerializer multipartFormRequestWithMethod:mothodStr
                                                                  URLString:apiStr
                                                                 parameters:theParams
                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                   {
                       for (NSString * aKey in files)
                       {
                           
                           [formData appendPartWithFileData:files[aKey] name:aKey fileName:[NSString stringWithFormat:@"%@.jpg", [NSDate date]] mimeType:@"image/jpeg"];
                       }
                       
                   } error:nil];
    } else
    {
        request = [manager.requestSerializer requestWithMethod:mothodStr
                                                     URLString:apiStr
                                                    parameters:initParams
                                                         error:nil];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //设置头
    for (NSString * key in headParamsDic)
    {
        NSString * string = [NSString stringWithFormat:@"%@",headParamsDic[key]];
        [manager.requestSerializer setValue:string forHTTPHeaderField:key];
    }
    //设置cookies
    //    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
    //    if([cookiesdata length]) {
    //        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
    //        NSHTTPCookie *cookie;
    //        for (cookie in cookies) {
    //            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        }
    //    }
    //    NSURLSessionDataTask * task = [[NSURLSessionDataTask alloc]init];
    if (httpMethod == HttpMethodPost)
    {
        
        if (files.count)
        {
            NSURLSessionTask * task = [manager POST:apiStr parameters:theParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                                       {
                                           for (NSString * aKey in files)
                                           {
                                               [formData appendPartWithFileData:files[aKey] name:aKey fileName:[NSString stringWithFormat:@"%@.jpg", [NSDate date]] mimeType:@"image/jpeg"];                                           }
                                       }
                                           progress:^(NSProgress *uploadProgress)
                                       {
                                           
                                       }
                                       
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
                                       {
                                           ResultBlk(nil,task,responseObject);
                                       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
                                       {
                                           ResultBlk(error,task,nil);
                                       }];
            return task;
        }else
        {
            return [manager POST:apiStr parameters:theParams progress:^(NSProgress *uploadProgress)
                    {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        ResultBlk(nil,task,responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        ResultBlk(error,task,nil);
                    }];
        }
        
        
        
    }else
    {
        NSURLSessionTask * task = [manager GET:apiStr
                                    parameters:theParams
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
                                   {
                                       ResultBlk(nil,task,responseObject);
                                   }
                                       failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
                                   {
                                       ResultBlk(error,task,nil);
                                   }];
        return task;
    }
    return nil;
}

-(id)wNetBase:(NSString *)apiStr
       Params:(NSDictionary *)paramsDic
   HeadParams:(NSDictionary *)headParamsDic
   HttpMethod:(HttpMethodType)typeHttpMethod
       Result:(void(^)(NSError * error,id request, NSData *  responseData))ResultBlk
{
    
    return [self wNetBase:apiStr HttpsCerMode:WHttpsModeNoHttps HttpsCerData:nil Params:paramsDic HeadParams:headParamsDic HttpMethod:typeHttpMethod Result:ResultBlk];
}

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
       Params:(NSDictionary *)paramsDic
   HeadParams:(NSDictionary *)headParamsDic
   HttpMethod:(HttpMethodType)typeHttpMethod
       Result:(void(^)(NSError * error,id request,id jsonObj,NSString * responseStr))ResultBlk
{
    return [self wNetJson:apiStr HttpsCerMode:WHttpsModeNoHttps HttpsCerData:nil Params:paramsDic HeadParams:headParamsDic HttpMethod:typeHttpMethod Result:ResultBlk];
}

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
       Result:(void(^)(NSError * error,id request,id jsonObj,NSString * responseStr))ResultBlk
{
    return [self wNetBase:apiStr
             HttpsCerMode:httpsMode
             HttpsCerData:httpsData
                   Params:paramsDic
               HeadParams:headParamsDic
               HttpMethod:typeHttpMethod
                   Result:^(NSError * error, id request, id responseObj)
            {
                NSString * responseStr = nil;
                id jsonObj = nil;
                if (!error)
                {
                    //已经是JSON数据
                    if ([NSJSONSerialization isValidJSONObject:responseObj])
                    {
                        jsonObj = responseObj;
                        
                        responseStr = [WJsonTool wJsonStrFromJsonObj:responseObj Error:nil];
                        
                    }
                    //字符串
                    else if ([responseObj isKindOfClass:[NSString class]])
                    {
                        NSError * errorJson = nil;
                        responseStr = [responseObj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        jsonObj = [WJsonTool wJsonObjFromJson:responseStr Error:&errorJson];
                        if (errorJson)//解析不成功
                        {
                            //                            NSLog(@"请求返回的不是JSON数据");
                            error = errorJson;
                        }
                    }
                    //Data数据
                    else if ([responseObj isKindOfClass:[NSData class]])
                    {
                        NSError * errorJson = nil;
                        responseStr = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
                        jsonObj = [WJsonTool wJsonObjFromJson:responseStr Error:&errorJson];
                        if (errorJson)//解析不成功
                        {
                            //                            NSLog(@"请求返回的不是JSON数据");
                            error = errorJson;
                        }
                    }
                    
                }
                ResultBlk(error,request,jsonObj,responseStr);
            }];
}






@end







