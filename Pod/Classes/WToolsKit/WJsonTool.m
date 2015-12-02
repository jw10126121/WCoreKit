//
//  WJsonTool.m
//  
//
//  Created by Linjw on 13-11-15.
//  Copyright (c) 2013年 Linjw. All rights reserved.
//

#import "WJsonTool.h"

@implementation WJsonTool

static BOOL _isHidenLogWhenErrorForStatic = NO;
+ (void)isHidenLogWhenError:(BOOL)isHidenLogWhenError
{
    _isHidenLogWhenErrorForStatic = isHidenLogWhenError;
}

#pragma mark - JSON

//JSON序列化
+(NSString *)wJsonStrFromJsonObj:(id)dictionaryOrArray Error:(NSError **)aError
{
    if (!dictionaryOrArray ) {
        return nil;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:aError];
    if (!jsonData && aError)
    {
        if (!_isHidenLogWhenErrorForStatic) {
            NSLog(@"JSON序列化出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,dictionaryOrArray);
        }
    }
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)//如果是MRC
    [jsonStr autorelease];
#endif
    return jsonStr;
}

- (NSString *)wJsonStrFromJsonObj:(id)dictionaryOrArray Error:(NSError **)aError
{
    if (!dictionaryOrArray) {
        return nil;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:aError];
    if (!jsonData && aError)
    {
        if (!_isHidenLogWhenErrorForStatic) {
             NSLog(@"JSON序列化出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,dictionaryOrArray);
        }
    }
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)//如果是MRC
    [jsonStr autorelease];
#endif
    return jsonStr;
}

//NSDictionary
+(NSDictionary *)wJsonDicFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    return [[self class] wJsonObjFromJson:jsonStr IsArrayOrDic:NO Error:aError];
}
- (NSDictionary *)wJsonDicFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    return [self wJsonObjFromJson:jsonStr IsArrayOrDic:NO Error:aError];
}

//NSDictionary
+(NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    return [[self class] wJsonObjFromJson:jsonStr IsArrayOrDic:YES Error:aError];
}
- (NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    return [self wJsonObjFromJson:jsonStr IsArrayOrDic:YES Error:aError];
}

+ (id)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    id obj = nil;
    obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
    if (!obj && aError)
    {
        if (!_isHidenLogWhenErrorForStatic) {
            NSLog(@"解析出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,jsonStr);
        }
        
    }
    return obj;
}

- (id)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    return [[self class] wJsonObjFromJson:jsonStr Error:aError];
}

//NSArray Or NSDictionary
+(id)wJsonObjFromJson:(NSString *)jsonStr IsArrayOrDic:(BOOL)isArray Error:(NSError **)aError
{
    if (jsonStr.length == 0)
    {
        return nil;
    }
    
    if (!isArray)
    {
        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
        if (!obj && aError)
        {
            if (!_isHidenLogWhenErrorForStatic) {
                NSLog(@"解析出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,jsonStr);
            }
            
        }
        return obj;
    }else
    {
        NSArray * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
        if (!obj && aError)
        {
            if (!_isHidenLogWhenErrorForStatic) {
           NSLog(@"解析出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,jsonStr);
            }
        }
        return obj;
    }
    return nil;
}

- (id)wJsonObjFromJson:(NSString *)jsonStr IsArrayOrDic:(BOOL)isArray Error:(NSError **)aError
{
    if (!isArray)
    {
        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
        if (!obj && aError)
        {
            if (!_isHidenLogWhenErrorForStatic) {
            NSLog(@"解析出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,jsonStr);
            }
        }
        return obj;
    }else
    {
        NSArray * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
        if (!obj && aError)
        {
            if (!_isHidenLogWhenErrorForStatic) {
            NSLog(@"解析出错:\nError:%@\nData:\n%@",(*aError).localizedDescription,jsonStr);
            }
        }
        return obj;
    }
    return nil;
//    return [WJsonTool wJsonObjectFromJson:jsonStr IsArrayOrDic:isArray Error:aError];
}


#if __has_feature(objc_arc)//如果是ARC
+ (WJsonTool *)sharedInstance{
    static WJsonTool *sharedWJsonTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWJsonTool = [[self alloc] init];
    });
    return sharedWJsonTool;
}
#else
static WJsonTool *sharedWJsonTool;
+ (WJsonTool *)sharedInstance
{
    @synchronized(self){
        if (sharedWJsonTool == nil){
            sharedWJsonTool = [[self alloc] init];
        }
    }
    return sharedWJsonTool;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount{
    return UINT_MAX;
}

- (oneway void) release{
}

- (id) autorelease
{
    return self;
}
#endif

@end



@implementation NSJSONSerialization (WJsonTool)

+(NSDictionary *)wJsonObjFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    if (jsonStr.length == 0)
    {
        return nil;
    }
    
    NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
    return obj;
}

+(NSArray *)wJsonArrFromJson:(NSString *)jsonStr Error:(NSError **)aError
{
    if (jsonStr.length == 0)
    {
        return nil;
    }
    NSArray * obj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
    return obj;
}

+(NSString *)wJsonStrFromJsonObj:(id)jsonObj Error:(NSError **)aError
{
    if ([NSJSONSerialization isValidJSONObject:jsonObj] == NO)
    {
        return nil;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:aError];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)//如果是MRC
    [jsonStr autorelease];
#endif
    return jsonStr;
}

@end

@implementation NSString (WJsonTool)


-(id)wJsonObjWithError:(NSError **)aError
{
    id obj = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:aError];
    return obj;
}

-(NSArray *)wJsonArrWithError:(NSError **)aError
{
    id obj = [self wJsonObjWithError:aError];
    if ([obj isKindOfClass:[NSArray class]])
    {
        return (NSArray *)obj;
    }
    return obj;
}

-(NSDictionary *)wJsonDicWithError:(NSError **)aError
{
    id obj = [self wJsonObjWithError:aError];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)obj;
    }
    return obj;
}

@end

@implementation NSDictionary (WJsonTool)

-(NSString *)wJsonStrWithError:(NSError **)aError
{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:aError];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)//如果是MRC
    [jsonStr autorelease];
#endif
    return jsonStr;
}

@end

@implementation NSArray (WJsonTool)

-(NSString *)wJsonStrWithError:(NSError **)aError
{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:aError];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)//如果是MRC
    [jsonStr autorelease];
#endif
    return jsonStr;
}

@end








