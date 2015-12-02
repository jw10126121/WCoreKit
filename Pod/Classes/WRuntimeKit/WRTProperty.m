//
//  WRTProperty.m
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import "WRTProperty.h"

@interface WRTProperty ()

@property(nonatomic,strong)NSString * cTypeInfo;//运行时显示的属性信息

@end

@implementation WRTProperty


-(void)wSetWithCProperty:(objc_property_t)cProperty
{
    //设置WRTProperty
    NSArray * attrPairs = [[NSString stringWithCString:property_getAttributes(cProperty) encoding:[NSString defaultCStringEncoding]] componentsSeparatedByString: @","]; //属性信息
    //C语言属性信息保存字典
//    NSMutableDictionary * attrs = [[NSMutableDictionary alloc] initWithCapacity:[attrPairs count]];
    self.name = [NSString stringWithCString:property_getName(cProperty) encoding:[NSString defaultCStringEncoding]];
    for (NSString * attrStr in attrPairs)
    {
        if (attrStr.length)
        {
            //取首字母
            NSString * firstLetter = [attrStr substringToIndex:1];
            NSString * value = [attrStr substringFromIndex:1];
            
            if ([firstLetter isEqualToString:@"T"])        //属性类型
            {
                self.cTypeInfo = value;
                self.type = [WRTProperty wPropertyTypeFromPropertyCTypeAcronym:value];
                break;
            }
            else if ([firstLetter isEqualToString:@"V"])   //属性名
            {
            }
            else if ([firstLetter isEqualToString:@"&"])    //NonAtomic
            {
                
            }

        }
    }

}

+ (NSString *)wPropertyTypeFromPropertyCTypeAcronym:(NSString *)cTypeAcronym
{
    NSString * strReturn = nil;
    cTypeAcronym = [cTypeAcronym stringByReplacingOccurrencesOfString:@"@" withString:@""];   //去掉@号
    cTypeAcronym = [cTypeAcronym stringByReplacingOccurrencesOfString:@"\"" withString:@""];  //去掉"号
    
    if ([cTypeAcronym isEqualToString:WPropertyTypeInt_C]) {
        strReturn = WPropertyTypeInt;
    }else if ([cTypeAcronym isEqualToString:WPropertyTypeLong_C]){
        strReturn = WPropertyTypeLong;
    }else if ([cTypeAcronym isEqualToString:WPropertyTypeBOOL_C1]
              || [cTypeAcronym isEqualToString:WPropertyTypeBOOL_C2]
              || [cTypeAcronym isEqualToString:WPropertyTypeBOOL_C3]
              || [cTypeAcronym isEqualToString:WPropertyTypeBOOL_C4]){
        strReturn = WPropertyTypeBOOL;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeLongLong_C]){
        strReturn = WPropertyTypeLongLong;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeFloat_C]){
        strReturn = WPropertyTypeFloat;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeDouble_C]){
        strReturn = WPropertyTypeDouble;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeUnsignedInt_C]){
        strReturn = WPropertyTypeUnsignedInt;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeUnsignedLong_C]){
        strReturn = WPropertyTypeUnsignedLong;
    }else if([cTypeAcronym isEqualToString:WPropertyTypeUnsignedLongLong_C]){
        strReturn = WPropertyTypeUnsignedLongLong;
    }
    else {
        strReturn = cTypeAcronym;
    }
    
    return strReturn;
}

@end
