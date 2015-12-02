//
//  WOrmManager.m
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import "WOrmManager.h"
#import "NSObject+WRTObject.h"
#import "WRTProperty.h"

//默认字符串时间格式
#define OrmDefaultDateFormatterString @"yyyy-MM-dd HH:mm:ss"

@implementation WOrmManager


/**
 *  得到代理对象的自有属性信息,以及从实现了<WOrmProtocol>的父类继承下来的属性信息
 *
 *  @return 属性信息数组(每个元素为WProperty对象)
 */
- (NSArray *) wPropertiesForWmodel:(id<WOrmProtocol>)aWmodel
{
    Class superClassHighest = [self wSuperClassWithWmodel:aWmodel]; //实现了<WOrmProtocol>的最高级父类
    NSArray * properties = [[aWmodel class] wPropertiesToSuperClass:superClassHighest IsIncludeSuperClass:NO];
    return properties;
}

+ (NSArray *) wPropertiesForWmodelClass:(Class<WOrmProtocol>)aWmodelClass
{
    Class superClassHighest = [self wSuperClassWithWmodelClass:aWmodelClass]; //实现了<WOrmProtocol>的最高级父类
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    NSArray * properties = [[aWmodelClass class] wPropertiesToSuperClass:superClassHighest IsIncludeSuperClass:NO];
#pragma clang diagnostic pop
    return properties;
}

//实现了<WOrmProtocol>的最高级父类
-(Class)wSuperClassWithWmodel:(id<WOrmProtocol>)aWmodel{
    Class currClass =  [aWmodel class];
    Class supClass = currClass;
    while ([supClass conformsToProtocol:@protocol(WOrmProtocol)]) {
        currClass = supClass;
        supClass = [currClass superclass];
    }
    return currClass;
}

//实现了<WOrmProtocol>的最高级父类
+(Class)wSuperClassWithWmodelClass:(Class<WOrmProtocol>)aWmodelClass{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    Class currClass =  [aWmodelClass superclass];
#pragma clang diagnostic pop
    Class supClass = currClass;
    while ([supClass conformsToProtocol:@protocol(WOrmProtocol)]) {
        currClass = supClass;
        supClass = [currClass superclass];
    }
    return currClass;
}


/**
 *  根据aWmodel生成属性信息NSDictionary
 *
 *  @param aWmodel   参与ORM的Model
 *  @param type      生成字典的类型
 *
 *  @return 根据aWmodel生成属性信息NSDictionary
 */
-(NSMutableDictionary *)wDicForWModel:(id<WOrmProtocol>)aWmodel Type:(NSInteger)type
{
    if (!aWmodel) {
        return nil;
    }
    NSArray *propertiesRT = [self wPropertiesForWmodel:aWmodel];
    NSMutableDictionary * dicReturn = nil;
    if (!propertiesRT.count) {
        return nil;
    }
    
    dicReturn = [[NSMutableDictionary alloc] initWithCapacity:propertiesRT.count];
    for (WRTProperty * proRuntime in propertiesRT)
    {
        NSString * propertyName = proRuntime.name;          //属性名
        NSString * propertyType = proRuntime.type;  //属性类型
        //基本数据
        if ([propertyType isEqualToString:NSStringFromClass([NSString class])] ||
            [propertyType isEqualToString:NSStringFromClass([NSNumber class])] ||
            [propertyType isEqualToString:WPropertyTypeInt] ||
            [propertyType isEqualToString:WPropertyTypeLong] ||
            [propertyType isEqualToString:WPropertyTypeLongLong] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedInt] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedLong] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedLongLong] ||
            [propertyType isEqualToString:WPropertyTypeFloat] ||
            [propertyType isEqualToString:WPropertyTypeDouble] )
        {
            id valuePro = [aWmodel valueForKey:propertyName];   //属性值
            if (valuePro)
            {
                [dicReturn setObject:valuePro forKey:propertyName];
            }else
            {
                [dicReturn setObject:[NSNull null] forKey:propertyName];
            }
        }
        //时间
        else if ([propertyType isEqualToString:NSStringFromClass([NSDate class])])
        {
            NSDate * valuePro = [aWmodel valueForKey:propertyName];   //属性值
            NSTimeInterval timeInterval = [valuePro timeIntervalSince1970];
            [dicReturn setObject:[NSNumber numberWithDouble:timeInterval]
                          forKey:propertyName];
        }
        else
        {
            continue;
        }
    }
    return dicReturn;
}

/**
 *  为aWmodel设置属性信息
 *
 *  @param aWmodel     参与ORM的Model
 *  @param dicForModel aWmodel的属性信息字典
 *  @param type        生成字典的类型
 *
 *  @return 为aWmodel设置属性信息成功？
 */
- (BOOL) wSetWmodel:(id<WOrmProtocol>)aWmodel DicForModel:(NSDictionary *)dicForModel Type:(NSInteger)type
{
    NSArray *propertiesRT = [self wPropertiesForWmodel:aWmodel];
    if (!propertiesRT.count || !dicForModel.count) {
        return NO;
    }
    
    for (WRTProperty * proRuntime in propertiesRT) {
        NSString * propertyName = proRuntime.name;          //属性名
        NSString * propertyType = proRuntime.type;  //属性类型
        id valueFromDic = dicForModel[propertyName];        //属性对应的key的value
        //---------根据DicForModel的Key,写入数据到对象中,不存在的排除---------
        if (![self isExistString:propertyName Array:dicForModel.allKeys]) {
            continue;
        }
        
        //基本数据类型与Null
        if (valueFromDic == [NSNull null] ||
            [propertyType isEqualToString:NSStringFromClass([NSString class])] ||
            [propertyType isEqualToString:NSStringFromClass([NSNumber class])] ||
            [propertyType isEqualToString:WPropertyTypeInt] ||
            [propertyType isEqualToString:WPropertyTypeLong] ||
            [propertyType isEqualToString:WPropertyTypeLongLong] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedInt] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedLong] ||
            [propertyType isEqualToString:WPropertyTypeUnsignedLongLong] ||
            [propertyType isEqualToString:WPropertyTypeFloat] ||
            [propertyType isEqualToString:WPropertyTypeDouble] )
        {
            [aWmodel setValue:valueFromDic forKey:propertyName];
        }
        //日期
        else if([propertyType isEqualToString:NSStringFromClass([NSDate class])] || [NSClassFromString(propertyType) isSubclassOfClass:[NSDate class]])
        {
            id date = nil;//[NSNull null];
            
            if (![[aWmodel class] respondsToSelector:@selector(wDateTypeForDateProName:)])
            {
                //自动判断服务器回传的类型
                if ([valueFromDic isKindOfClass:[NSNumber class]])
                {
                    //                    long long int dtServer = [valueFromDic longLongValue];
                    //                    long long int dtLocal = dtServer;
                    //                    if(dtServer > 9999999999)
                    //                    {
                    //                        dtLocal = dtServer;
                    //                        while (dtLocal > 9999999999)
                    //                        {
                    //                            dtLocal = dtLocal/10;
                    //                        }
                    //                    }
                    //                    date = [NSDate dateWithTimeIntervalSince1970:dtLocal];
                    date = [[self class] wDateWithNum:valueFromDic];
                }else if([valueFromDic isKindOfClass:[NSString class]])
                {
                    if ([[aWmodel class] resolveClassMethod:@selector(wDateFormatterForDateProName:)])
                    {
                        NSDateFormatter * dateFormatter = [[aWmodel class] wDateFormatterForDateProName:propertyName];
                        if (dateFormatter) {
                            date = [dateFormatter dateFromString:valueFromDic];
                        }else{
                            date = [NSNull null];
                        }
                    }
                    else{
                        date = [NSNull null];
                    }
                }else
                {
                    NSLog(@"非时间类型数据.");
                }
            }else
            {
                ORMDateType dateType = [[aWmodel class] wDateTypeForDateProName:propertyName];
                switch (dateType) {
                    case ORMDateType_S:{
                        //                        date = [NSDate dateWithTimeIntervalSince1970:[valueFromDic doubleValue]];
                        date = [[self class] wDateWithNum:valueFromDic];
                        break;
                    }
                    case ORMDateType_Str:{
                        NSDateFormatter * dateFormatter = [[aWmodel class] wDateFormatterForDateProName:propertyName];
                        if (dateFormatter) {
                            date = [dateFormatter dateFromString:valueFromDic];
                        }else{
                            date = [NSNull null];
                        }
                        break;
                    }
                    case ORMDateType_MS:{
                        //                        date = [NSDate dateWithTimeIntervalSince1970:[valueFromDic longLongValue]/1000];
                        date = [[self class]wDateWithNum:valueFromDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            
            [aWmodel setValue:date forKey:propertyName];
        }
        
        //某个对象(值是dic,属性类型不是dic,也不是字符串)
        else if ([valueFromDic isKindOfClass:[NSDictionary class]] &&
                 ![propertyType isEqualToString:NSStringFromClass([NSDictionary class])] &&
                 ![propertyType isEqualToString:NSStringFromClass([NSString class])])
        {
            NSDictionary * dicPropertyValue = (NSDictionary *)valueFromDic;
            Class objCls = NSClassFromString(propertyType);
            id childObj = [[objCls alloc] init];
            [self wSetWmodel:childObj DicForModel:dicPropertyValue Type:type];
            [aWmodel setValue:childObj forKey:propertyName];
#if !__has_feature(objc_arc)//mrc
            [childObj release];
#endif
        }
        //数组
        else if ([valueFromDic isKindOfClass:[NSArray class]] &&
                 [propertyType isEqualToString:NSStringFromClass([NSArray class])] ){
            NSArray * arrPropertyValue = (NSArray *)valueFromDic;
            Class objCls = nil;
            if ([[aWmodel class] resolveClassMethod:@selector(wClassWithObjectOfArrayName:)])
            {
                objCls = [[aWmodel class] wClassWithObjectOfArrayName:propertyName];
            }
            if (objCls){
                NSMutableArray * array = [[NSMutableArray alloc]init];
                for (int i = 0; i<arrPropertyValue.count; i++) {
                    if ([arrPropertyValue[i] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary * dicPropertyValue = arrPropertyValue[i];
                        id childObj = [[objCls alloc] init];
                        if ([childObj conformsToProtocol:@protocol(WOrmProtocol)])
                        {
                            [self wSetWmodel:childObj DicForModel:dicPropertyValue Type:type];
                            [array addObject:childObj];
                        }
                        
#if !__has_feature(objc_arc)//mrc
                        [childObj release];
#endif
                    }else if([arrPropertyValue[i] isKindOfClass:[NSString class]])
                    {
                        [array addObject:arrPropertyValue[i]];
                    }else if ([arrPropertyValue[i] isKindOfClass:[NSNumber class]]){
                        [array addObject:arrPropertyValue[i]];
                    }
                }
                [aWmodel setValue:array forKey:propertyName];
#if !__has_feature(objc_arc)//mrc
                [array release];
#endif
            }
            
        }
        //判断是否是字符串类型,且Dic中Value如果是数组类型,就改变
        else if ([propertyType isEqualToString:NSStringFromClass([NSString class])] &&
                 [valueFromDic isKindOfClass:[NSArray class]]) {
            NSArray * arr = (NSArray*) valueFromDic;
            NSString* arrString = [arr componentsJoinedByString:@","];
            [aWmodel setValue:arrString forKey:propertyName];
        }
        //Null
        else if (valueFromDic == [NSNull null]){
            [aWmodel setValue:[NSNull null] forKey:propertyName];
        }
        else{
            if (valueFromDic && valueFromDic != [NSNull null]) {
                [aWmodel setValue:valueFromDic forKey:propertyName];
            }
        }
    }
    return YES;
}

/**
 *  得到delegate的属性信息
 *
 *  @param noNull 是否取不为空的属性信息
 *
 *  @return delegate的属性信息
 */
- (NSDictionary *)wDicDescriptionForWmodel:(id<WOrmProtocol>)aWmodel WhenHideNull:(BOOL)noNull{
    //得到所有属性信息(WProperty)
    NSArray * propertiesRT = [self wPropertiesForWmodel:aWmodel];
    if (!propertiesRT.count) {
        return [NSDictionary dictionary];
    }
#if !__has_feature(objc_arc)//mrc
    NSMutableDictionary * dicReturn = [[[NSMutableDictionary alloc] init] autorelease];
#else
    NSMutableDictionary * dicReturn = [[NSMutableDictionary alloc] init];
#endif
    for (WRTProperty * proRuntime in propertiesRT) {
        NSString * nameProperty = proRuntime.name;//属性名
        id valueProperty = [aWmodel valueForKey:nameProperty];//属性值
        if (noNull) {
            //不加入值为Null或nil的属性
            if ([valueProperty isEqual:[NSNull null]] || !valueProperty) {
                continue;
            }
        }
        //加入所有Null或者nil对象
        if ([valueProperty isEqual:[NSNull null]] || !valueProperty) {
            [dicReturn setValue:[NSNull null] forKey:nameProperty];
        }
        //加入NSNumber或者NSString对象
        else if ([valueProperty isKindOfClass:[NSNumber class]] || [valueProperty isKindOfClass:[NSString class]]){
            [dicReturn setObject:valueProperty forKey:nameProperty];
        }
        //加入时间对象
        else if ([valueProperty isKindOfClass:[NSDate class]] || [nameProperty isEqualToString:NSStringFromClass([NSDate class])]){
            NSDate * dateValue = (NSDate *)valueProperty;
            NSDateFormatter * dateFormatter = [self wGetDefaultDateFormatter];
            NSString * valueStr = [dateFormatter stringFromDate:dateValue];
            [dicReturn setObject:valueStr forKey:nameProperty];
        }
        //加入实现了<WOrmProtocol>的对象
        else if([valueProperty conformsToProtocol:@protocol(WOrmProtocol)]){
            NSDictionary * dic = [self  wDicDescriptionForWmodel:valueProperty WhenHideNull:noNull];
            [dicReturn setObject:dic forKey:nameProperty];
        }
        //判断数组
        else if ([valueProperty isKindOfClass:[NSArray class]]){
            NSArray * subModels =(NSArray *)valueProperty;
            NSMutableArray * arr = [[NSMutableArray alloc]initWithCapacity:subModels.count];
            for (int i = 0; i<subModels.count; i++){
                if ([subModels[i] isEqual:[NSNull null]] || !subModels[i]) {
                    [arr addObject:[NSNull  null]];
                }else if ([subModels[i] isKindOfClass:[NSString class]] || [subModels[i] isKindOfClass:[NSNumber class]]){
                    [arr addObject:subModels[i]];
                }else if ([subModels[i] conformsToProtocol:@protocol(WOrmProtocol)]){
                    NSDictionary * dic = [self wDicDescriptionForWmodel:subModels[i] WhenHideNull:noNull];
                    [arr addObject:dic];
                }else if ([subModels[i] isKindOfClass:[NSDate class]] && ![subModels[i] isEqual:[NSNull null]]){
                    NSDate * dateValue = (NSDate *)subModels[i];
                    NSDateFormatter * dateFormatter = [self wGetDefaultDateFormatter];
                    if (!dateFormatter) {
                        dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:OrmDefaultDateFormatterString];
                        NSString * valueStr = [dateFormatter stringFromDate:dateValue];
#if !__has_feature(objc_arc)//mrc
                        [dateFormatter release];
#endif
                        [dicReturn setObject:valueStr forKey:nameProperty];
                    }else{
                        NSString * valueStr = [dateFormatter stringFromDate:dateValue];
                        [dicReturn setObject:valueStr forKey:nameProperty];
                    }
                }else{
                    [arr addObject:subModels[i]];
                }
            }
            [dicReturn setObject:arr forKey:nameProperty];
#if !__has_feature(objc_arc)//mrc
            [arr release];
#endif
        }
        else{
            NSLog(@"包含未被支持的对象:(%@)",proRuntime);
            [dicReturn setObject:valueProperty forKey:nameProperty];
        }
    }
    return dicReturn;
}

/**
 *  得到aWmodel的属性信息
 *
 *  @param aWmodelClass 参与ORM的类
 *
 *  @return 得到aWmodel的属性信息
 */
+ (NSString *)wCreatTableForWmodel:(Class<WOrmProtocol>)aWmodelClass
{
    NSArray * propertiesRT = [self wPropertiesForWmodelClass:aWmodelClass];
    NSString * tableName = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([[aWmodelClass class] respondsToSelector:@selector(wTableName)])
#pragma clang diagnostic pop
    {
        tableName = [aWmodelClass wTableName];
    }else
    {
        tableName = [NSString stringWithFormat:@"tb_%@",NSStringFromClass(aWmodelClass)];
    }
    
    NSMutableString * sql = [[NSString new] mutableCopy];
    //    [sql appendFormat:@"CREATE TABLE %@ ",tableName];
    for (WRTProperty * proRuntime in propertiesRT)
    {
        NSString * nameProperty = proRuntime.name;//属性名
        NSString * typeProperty = proRuntime.type;//属性类型
        NSString * databaseKey = [self dataBaseKeyNameWithWRTPropertyTypeStr:typeProperty];
        if (databaseKey.length == 0) continue;  //去掉非基本属性
        [sql appendFormat:@"%@ %@,",nameProperty,databaseKey];
    }
    
    NSArray * primaryKeys = nil;
    NSString * primaryStr = @"";
    //去掉最后的,
    if ([sql hasSuffix:@","]) [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([[aWmodelClass class] respondsToSelector:@selector(wPrimaryKeys)])
#pragma clang diagnostic pop
    {
        
        primaryKeys = [aWmodelClass wPrimaryKeys];
        primaryStr = [primaryKeys componentsJoinedByString:@","];
        primaryStr = [NSString stringWithFormat:@",PRIMARY KEY(%@)",primaryStr];
    }
    
    NSString * toSql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@%@)",[aWmodelClass wTableName],sql,primaryStr];
    return toSql;
}

+(NSString *)dataBaseKeyNameWithWRTPropertyTypeStr:(NSString *)propertyTypeStr
{
    NSString * key = @"";
    if ([propertyTypeStr isEqualToString:@"NSString"])
    {
        key = @"TEXT";
    } else if ([propertyTypeStr isEqualToString:@"NSNumber"])
    {
        key = @"INTEGER";
    } else if ([propertyTypeStr isEqualToString:WPropertyTypeDouble] ||
               [propertyTypeStr isEqualToString:WPropertyTypeFloat])
    {
        key = [propertyTypeStr uppercaseString];
    } else if ([propertyTypeStr isEqualToString:WPropertyTypeLong] || [propertyTypeStr isEqualToString:WPropertyTypeInt] || [propertyTypeStr isEqualToString:WPropertyTypeUnsignedLong] || [propertyTypeStr isEqualToString:WPropertyTypeUnsignedInt])
    {
        key = @"INTEGER";
    } else if ([[propertyTypeStr uppercaseString] isEqualToString:WPropertyTypeBOOL])
    {
        key = @"BOOLEAN";
    } else if ([[propertyTypeStr uppercaseString] isEqualToString:WPropertyTypeLongLong])
    {
        key = @"INTEGER";
    }
    return key;
}

#pragma mark -
//数组中是否存在字符串
- (BOOL) isExistString:(NSString *)aString Array:(NSArray *)aArray{
    //数组为空，或者字符串不存在
    if (!aString || !aArray.count) {
        return NO;
    }
    
    BOOL isExist = NO;
    for (NSUInteger i = 0 ; i < aArray.count; i++) {
        //对象的类型为NSString,且字符串值相同,就存在
        if ([[aArray objectAtIndex:i] isKindOfClass:[NSString class]] && [[aArray objectAtIndex:i] isEqualToString:aString]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

-(NSDateFormatter *)wGetDefaultDateFormatter{
#if !__has_feature(objc_arc)//mrc
    NSDateFormatter * defDateForma = [[[NSDateFormatter alloc]init] autorelease];
#else
    NSDateFormatter * defDateForma = [[NSDateFormatter alloc]init];
#endif
    [defDateForma setDateFormat:OrmDefaultDateFormatterString];
    return defDateForma;
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


@end
