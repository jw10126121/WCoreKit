//
//  WOrmBaseModel.h
//
//
//  Created by linjiawei on 13-11-22.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WOrmProtocol.h"


#define DefaultTimeStyleStr @"yyyy-MM-dd HH:mm:ss"

/**
 *  使用ORM的对象的父类
 *  @param - 注意:
 *  @param 1 这个对象最好不要加入任何属性信息
 *  @param 2 如果有包含属性对应的数组,请重写wClassWithObjectOfArrayName:方法,以设置数组信息
 */
@interface WOrmBaseModel : NSObject<WOrmProtocol>

//判断DicForModel是否可用
-(BOOL)wCheckDicForModelEnable:(NSDictionary *)dicForModel;

//model解析
-(void)wCheckModelWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)aClass;
-(void)wCheckModelWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)aClass;

//数组解析
-(void)wCheckArrayWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)itemClass;
-(void)wCheckArrayWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)itemClass;

//字符串时间解析
-(void)wCheckDateStrWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel DateFormatterStr:(NSString *)formatter;
-(void)wCheckDateStrWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel DateFormatterStr:(NSString *)formatter;
//时间戳时间解析
-(void)wCheckDateNumWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel;
-(void)wCheckDateNumWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel;

//填充时间到dicForModel
-(void)wInputDateStrToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key DateFormatterStr:(NSString *)formatter;
-(void)wInputDateStrToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key PropertyStr:(NSString *)property DateFormatterStr:(NSString *)formatter;
-(void)wInputDateNumToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key PropertyStr:(NSString *)property;
//填充对象到dicForModel
-(void)wInputModelToDic:(NSMutableDictionary *)dicForModel PropertyStr:(NSString *)propertyStr Property:(id<WOrmProtocol>)property Tag:(NSInteger)tag;

-(void)wInputArrayToDic:(NSMutableDictionary *)dicForModel DicKey:(NSString *)key Tag:(NSInteger)tag;
-(void)wInputArrayToDic:(NSMutableDictionary *)dicForModel DicKey:(NSString *)key PropertyStr:(NSString *)property Tag:(NSInteger)tag;



@end











