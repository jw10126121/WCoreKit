//
//  WOrmProtocol.h
//
//
//  Created by linjiawei on 13-11-22.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//
#define WGet_Dic_Obj_Key(dicForModel,obj,key) if (obj) [dicForModel setObject:obj forKey:key]

#define WSet_Dic_String_Key(dicForModel,string,key) \
if([dicForModel objectForKey:key] && [dicForModel objectForKey:key] != [NSNull null])\
string = [dicForModel objectForKey:key];

#define WSet_Dic_String_Key_Default(dicForModel,string,key,defaultKey) \
if([dicForModel objectForKey:key] && [dicForModel objectForKey:key] != [NSNull null]) string = [NSString stringWithFormat:@"%@",[dicForModel objectForKey:key]]; \
else string = defaultKey;

#define WSet_Dic_Long_Long_Key(dic,num,key) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) num = [[dic objectForKey:key] longLongValue]; \
else num = 0;

#define WSet_Dic_Int_Key(dic,num,key) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) num = [[dic objectForKey:key] intValue]; \
else num = 0;

#define WSet_Dic_Int_Key_Default(dic,numPro,key,default) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) numPro = [[dic objectForKey:key] intValue]; \
else numPro = default;

#define WSet_Dic_Num_Key(dic,num,key) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) num = [dic objectForKey:key];

#define WSet_Dic_Float_Key(dic,num,key) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) num = [[dic objectForKey:key] floatValue]; \
else num = 0;

#define WSet_Dic_Bool_Key(dic,num,key) \
if([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null]) num = [[dic objectForKey:key] boolValue]; \
else num = 0;

#import <Foundation/Foundation.h>

//时间类型
typedef NS_ENUM(NSInteger, ORMDateType)
{
    ORMDateType_S,              //秒(默认)
    ORMDateType_MS,             //毫秒
    ORMDateType_Str             //字符串
};

/**
 *  定义协议,规范使用ORM
 */
@protocol WOrmProtocol <NSObject>

@optional

/**
 *  设置model的属性
 *
 *  @param dicForModel   model对应的字典
 *  @param type 操作类型
 */
-(void)wSetModelWithDic:(NSDictionary *)dicForModel Type:(NSInteger)type;

/**
 *  得到dic数据
 *
 *  @param type 数据来源类型
 *
 *  @return dic数据
 */
-(NSMutableDictionary *) wDicFromModelWithType:(NSInteger)type;

/**
 *  数组元素对应的Class
 *
 *  @param propertyNameForArray 属性数组名
 *
 *  @return 数组元素对应的Class
 */
+(Class)wClassWithObjectOfArrayName:(NSString *)propertyNameForArray;


/**
 *  不参加ORM的属性名列表
 *
 *  @param dataType      数据来源类型
 *  @param isWhenSetDic  是否是在设置Dic的时候排除
 *
 *  @return 不参加ORM的属性名列表
 */
+(NSArray *)wExcludePropertyNamesWithDataType:(NSInteger)dataType
                                 IsWhenSetDic:(BOOL)isWhenSetDic;

/**
 *  得到主键名列表
 *
 *  @return 主键名数组
 */
+(NSArray *)wPrimaryKeys;

/**
 *  得到model对应的表名
 *  默认:tableName = [NSString stringWithFormat:@"tb_%@",NSStringFromClass([self class])];
 *
 *  @return NSString 当前model对应的表名
 */
+(NSString *)wTableName;

/**
 *  得到建表语句
 *
 *  @return NSString 建表语句
 */
+(NSString *)wSqlForCreateTable;

/**
 *  NSDate类型的属性对应的格式(仅当ormDateType == ORMDateType_Str时,有效)
 *
 *  @param dateProName NSDate类型的属性名(可设置所有NSDate属性的格式)
 *
 *  @return NSDate类型的属性对应的格式
 */
+(NSDateFormatter *)wDateFormatterForDateProName:(NSString *)dateProName;

/**
 *  NSDate类型的属性对应的日期表达类型(默认为 ORMDateType_S )
 *
 *  @param dateProName NSDate类型的属性名
 *
 *  @return NSDate类型的属性对应的日期表达类型
 */
+(ORMDateType)wDateTypeForDateProName:(NSString *)dateProName;


#pragma mark - 防止警告和错误
//防止警告和错误
@optional
+ (id)alloc;
- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

//+ (NSArray *) wPropertiesToSuperClass:(Class)superClass IsIncludeSuperClass:(BOOL)isInclude;

@end


























