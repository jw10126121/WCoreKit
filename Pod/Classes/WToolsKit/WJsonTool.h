//
//  WJsonTool.h
//
//
//  Created by Linjw on 13-11-15.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  JSON工具(仅支持IOS5及以上)
 */
@interface WJsonTool : NSObject

/**
 *  是否隐藏错误日志(默认打印出错误信息)
 *
 *  @param isHidenLogWhenError 是否不打印错误信息
 */
+ (void)isHidenLogWhenError:(BOOL)isHidenLogWhenError;

#pragma mark - 单例

+ (WJsonTool *)sharedInstance;

#pragma mark - JSON序列化

/**
 *  JSON序列化
 *
 *  @param dictionaryOrArray JSON对象(数组或字典)
 *  @param aError            错误
 *
 *  @return Json字符串
 */
+ (NSString *)wJsonStrFromJsonObj:(id)dictionaryOrArray Error:(NSError **)aError;
- (NSString *)wJsonStrFromJsonObj:(id)dictionaryOrArray Error:(NSError **)aError;
/**
 *  JSON解析
 *
 *  @param jsonStr Json字符串
 *  @param aError  错误
 *
 *  @return JSON对象(字典)
 */
+ (NSDictionary *)wJsonDicFromJson:(NSString *)jsonStr Error:(NSError **)aError;
- (NSDictionary *)wJsonDicFromJson:(NSString *)jsonStr Error:(NSError **)aError;
/**
 *  JSON解析
 *
 *  @param jsonStr Json字符串
 *  @param aError  错误
 *
 *  @return JSON对象(数组)
 */
+ (NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError;
- (NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError;

#pragma mark - JSON解析

/**
 *  JSON解析
 *
 *  @param jsonStr Json字符串
 *  @param aError  错误
 *
 *  @return JSON对象(数组或字典)
 */
+ (id)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError;
- (id)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError;

/**
 *  JSON解析
 *
 *  @param jsonStr Json字符串
 *  @param isArray 是否是数组,否为字典
 *  @param aError  错误
 *
 *  @return JSON对象(数组或字典)
 */
+ (id)wJsonObjFromJson:(NSString *)jsonStr IsArrayOrDic:(BOOL)isArray Error:(NSError **)aError;
- (id)wJsonObjFromJson:(NSString *)jsonStr IsArrayOrDic:(BOOL)isArray Error:(NSError **)aError;


@end


@interface NSJSONSerialization (WJsonTool)

+(NSDictionary *)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError;
+(NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError;
+(NSString *)wJsonStrFromJsonObj:(id)jsonObj Error:(NSError **)aError;


@end

@interface NSString (WJsonTool)

-(id)wJsonObjWithError:(NSError **)aError;
-(NSArray *)wJsonArrWithError:(NSError **)aError;
-(NSDictionary *)wJsonDicWithError:(NSError **)aError;

@end

@interface NSDictionary (WJsonTool)

-(NSString *)wJsonStrWithError:(NSError **)aError;

@end

@interface NSArray (WJsonTool)

-(NSString *)wJsonStrWithError:(NSError **)aError;




@end










