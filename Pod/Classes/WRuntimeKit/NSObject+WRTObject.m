//
//  WRTObject.m
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import "NSObject+WRTObject.h"
#import "WRTProperty.h"
#import <objc/runtime.h>

@implementation NSObject (WRTObject)

/**
 *  所有属性信息
 */
+(NSArray *)wProperties
{
    unsigned int count;
    //得到属性列表
    objc_property_t * list = class_copyPropertyList([self class], &count);
    NSMutableArray * array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++){
        WRTProperty * pro = [[WRTProperty alloc] init];
        objc_property_t cProperty = list[i];
        [pro wSetWithCProperty:cProperty];
        [array addObject:pro];
    }
    free(list);
    return array;
}


+ (NSArray *) wPropertiesIncludeSuperClass:(Class)superClass{
    
    NSMutableArray * array = [NSMutableArray array];
    Class currentClass = self;
    if([self class] == superClass){
        [array addObjectsFromArray:[superClass wProperties]];
    }else if (superClass && [self isSubclassOfClass:superClass]) {
        while (superClass != currentClass) {
            NSArray * arrCu = [currentClass wProperties];
            [array addObjectsFromArray:arrCu];
            currentClass = [currentClass superclass];
            if (currentClass == [NSObject class]) {
                break;
            }
        }
    }else{
        [array addObjectsFromArray:[self wProperties]];
    }
    return array;
}

+ (NSArray *) wPropertiesToSuperClass:(Class)superClass IsIncludeSuperClass:(BOOL)isInclude {
    NSMutableArray * array = [NSMutableArray array];
    Class currentClass = self;
    if([self class] == superClass){
        [array addObjectsFromArray:[superClass wProperties]];
    }else if (superClass && [self isSubclassOfClass:superClass]) {
        while (superClass != currentClass) {
            NSArray * arrCu = [currentClass wProperties];
            [array addObjectsFromArray:arrCu];
            currentClass = [currentClass superclass];
            if (currentClass == [NSObject class]) {
                break;
            }
        }
        
        if (isInclude) {
            [array addObjectsFromArray:[superClass wProperties]];
        }
        
    }else{
        [array addObjectsFromArray:[self wProperties]];
    }
    return array;
}

+ (WRTProperty *)wPropertyForName: (NSString *)name {
    objc_property_t property = class_getProperty([self class], [name?:@"" UTF8String]);
    if(!property || !name.length) return nil;
    WRTProperty * proper = [[WRTProperty alloc]init];
    [proper wSetWithCProperty:property];
    return proper;
}


@end
