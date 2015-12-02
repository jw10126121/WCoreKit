//
//  WOrmBaseModel.m
//
//
//  Created by linjiawei on 13-11-22.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import "WOrmBaseModel.h"
#import "WOrmManager.h"


@implementation WOrmBaseModel

+ (NSDate *)wDateWithString:(NSString *)dateStr StrFormatter:(NSString *)strFormatter{
    NSDate * date = nil;
    if (!dateStr || !dateStr.length) {
        return nil;
    }
    
    if (!strFormatter.length ||!strFormatter) {
        strFormatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:strFormatter];
    date = [[self class] wDateWithString:dateStr DateFormatter:dateFormatter];
    return date;
}

+ (NSDate *)wDateWithString:(NSString *)dateStr DateFormatter:(NSDateFormatter *)dateFormatter{
    NSDate * date = nil;
    if (!dateStr || !dateStr.length) {
        return nil;
    }
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    date = [dateFormatter dateFromString:dateStr];
    return date;
}

//生成时间
+ (NSDate *)wDateWithNum:(NSNumber *)dateNum
{
    long long int dtServer = [dateNum longLongValue];
    long long int dtLocal = dtServer;
    
    if(dtServer > 9999999999)
    {
        dtLocal = dtServer;
        while (dtLocal > 9999999999)
        {
            dtLocal = dtLocal/10;
        }
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:dtLocal];
    return date;
}
+(NSString *)wDateStrWithDate:(NSDate *)date FormatterStr:(NSString *)formatterStr
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:formatterStr];
    NSString *timestamp_str = [outputFormatter stringFromDate:date];
    return timestamp_str;
    
}

#pragma mark Other

-(void)__checkDicKey:(NSString *)key PropertyStr:(NSString *)propertyStr
{
    if (key.length && !propertyStr.length)
    {
        propertyStr = key;
    }else if(!key.length && propertyStr.length)
    {
        key = propertyStr;
    }
}

#pragma mark ------------

-(BOOL)wCheckDicForModelEnable:(NSDictionary *)dicForModel
{
    return (dicForModel && [dicForModel isKindOfClass:[NSDictionary class]]);
}

-(void)wCheckModelWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)aClass
{
    [self wCheckModelWithDicKey:key PropertyStr:key Dic:dicForModel Class:aClass];
}

-(void)wCheckModelWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)aClass
{
    [self __checkDicKey:key PropertyStr:property];
    id dicTemp = dicForModel[key];
    if (dicTemp && [dicTemp isKindOfClass:[NSDictionary class]])//防止[NSNull null]
    {
        id<WOrmProtocol> model = [[aClass alloc]init];
        [model wSetModelWithDic:(NSDictionary *)dicTemp Type:YES];
        [self setValue:model forKey:property];
    }
}

-(void)wCheckArrayWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)itemClass
{
    [self wCheckArrayWithDicKey:key PropertyStr:key Dic:dicForModel Class:itemClass];
}

-(void)wCheckArrayWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel Class:(Class<WOrmProtocol>)itemClass
{
    [self __checkDicKey:key PropertyStr:property];
    
    id array = dicForModel[key];
    if (array && [array isKindOfClass:[NSArray class]])//防止[NSNull null]
    {
        NSMutableArray * modelArr = [[NSMutableArray alloc]init];
        
        for (id itemArray in (NSArray *)array)
        {
            if ([itemArray isKindOfClass:[NSDictionary class]])
            {
                id<WOrmProtocol> model = [[itemClass alloc]init];
                [model wSetModelWithDic:itemArray Type:YES];
                [modelArr addObject:model];
            }
        }
        [self setValue:modelArr forKey:property];
    }
}

-(void)wCheckDateStrWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel DateFormatterStr:(NSString *)formatter
{
    [self wCheckDateStrWithDicKey:key PropertyStr:key Dic:dicForModel DateFormatterStr:formatter];
}

-(void)wCheckDateStrWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel DateFormatterStr:(NSString *)formatter
{
    [self __checkDicKey:key PropertyStr:property];
    if (dicForModel && [dicForModel isKindOfClass:[NSDictionary class]])
    {
        if (!formatter.length)
        {
            formatter = DefaultTimeStyleStr;
        }
        id date = dicForModel[key];
        if (date && [date isKindOfClass:[NSString class]])//防止[NSNull null]
        {
            NSDate * dateObj = [[self class] wDateWithString:date StrFormatter:formatter];
            [self setValue: dateObj forKey:property];
        }
    }
}

-(void)wCheckDateNumWithDicKey:(NSString *)key Dic:(NSDictionary *)dicForModel
{
    [self wCheckDateNumWithDicKey:key PropertyStr:key Dic:dicForModel];
}

//时间戳时间
-(void)wCheckDateNumWithDicKey:(NSString *)key PropertyStr:(NSString *)property Dic:(NSDictionary *)dicForModel
{
    [self __checkDicKey:key PropertyStr:property];
    if (dicForModel && [dicForModel isKindOfClass:[NSDictionary class]])
    {
        id date = dicForModel[key];
        if (date && ([date isKindOfClass:[NSNumber class]] || [date isKindOfClass:[NSString class]]))//防止[NSNull null]
        {
            NSDate * dateObj = [[self class] wDateWithNum:date];
            [self setValue: dateObj forKey:property];
        }
    }
}



-(void)wInputDateStrToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key DateFormatterStr:(NSString *)formatter
{
    [self wInputDateStrToDic:dicForModel Key:key PropertyStr:key DateFormatterStr:formatter];
}

-(void)wInputDateStrToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key PropertyStr:(NSString *)property DateFormatterStr:(NSString *)formatter
{
    [self __checkDicKey:key PropertyStr:property];
    if (dicForModel && [dicForModel isKindOfClass:[NSMutableDictionary class]])
    {
        if (!formatter.length)
        {
            formatter = DefaultTimeStyleStr;
        }
        
        id date = [self valueForKey:property];
        if (date && [date isKindOfClass:[NSDate class]])
        {
            dicForModel[key] = [[self class] wDateStrWithDate:date FormatterStr:formatter];
        }
    }
}



-(void)wInputDateNumToDic:(NSMutableDictionary *)dicForModel Key:(NSString *)key PropertyStr:(NSString *)property
{
    [self __checkDicKey:key PropertyStr:property];
    
    if (dicForModel && [dicForModel isKindOfClass:[NSMutableDictionary class]])
    {
        id date = [self valueForKey:property];
        if (date && [date isKindOfClass:[NSDate class]])
        {
            dicForModel[key] = @([date timeIntervalSince1970]);
        }
    }
    
}

-(void)wInputModelToDic:(NSMutableDictionary *)dicForModel
            PropertyStr:(NSString *)propertyStr
               Property:(id<WOrmProtocol>)property
             Tag:(NSInteger)isJson
{
    if (dicForModel)
    {
        if (property)
        {
            NSDictionary * dicProperty = [property wDicFromModelWithType:isJson];
            dicForModel[propertyStr] = dicProperty;
        }
    }
}

-(void)wInputArrayToDic:(NSMutableDictionary *)dicForModel DicKey:(NSString *)key Tag:(NSInteger)tag
{
    [self wInputArrayToDic:dicForModel DicKey:key PropertyStr:key Tag:tag];
}

-(void)wInputArrayToDic:(NSMutableDictionary *)dicForModel DicKey:(NSString *)key PropertyStr:(NSString *)property Tag:(NSInteger)tag
{
    [self __checkDicKey:key PropertyStr:property];
    
    if (dicForModel && [dicForModel isKindOfClass:[NSMutableDictionary class]])
    {
        id data = [self valueForKey:property];
        if (data && [data isKindOfClass:[NSArray class]])
        {
            NSArray * dataArray = (NSArray *)data;
            NSMutableArray * dataTemp = [[NSMutableArray alloc]init];
            for (int i = 0; i < dataArray.count; i ++)
            {
                id<WOrmProtocol> instance = dataArray[i];
                NSMutableDictionary * dic = [instance wDicFromModelWithType:tag];
                [dataTemp addObject:dic];
            }
            dicForModel[key] = dataTemp;
        }
    }
}


-(void)wSetModelWithDic:(NSDictionary *)dicForModel Type:(NSInteger)type
{
    if ([self wCheckDicForModelEnable:dicForModel] == NO)
    {
        return;
    }
    
    WOrmManager * managerORM = [[WOrmManager alloc]init];
    [managerORM wSetWmodel:self DicForModel:dicForModel Type:type];
    
}



+(NSString *)wTableName
{
    return [NSString stringWithFormat:@"tb_%@",NSStringFromClass([self class])];
}


-(NSDictionary *)wDicFromModelWithType:(NSInteger)type
{
    NSMutableDictionary * dicForModel = [[NSMutableDictionary alloc]init];

        WOrmManager * managerORM = [[WOrmManager alloc]init];
        dicForModel = [managerORM wDicForWModel:self Type:type];
    return dicForModel;
}

+(NSString *)wSqlForCreateTable
{
    //    WOrmManager * managerORM = [[WOrmManager alloc]init];
    return [WOrmManager wCreatTableForWmodel:[self class]];
}
@end



