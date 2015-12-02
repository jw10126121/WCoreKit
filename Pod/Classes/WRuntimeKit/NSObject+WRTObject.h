//
//  WRTObject.h
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WRTProperty;

@interface NSObject (WRTObject)


#pragma mark - 属性

/**
 *  得到当前类的所有属性信息(不包括从父类继承得到的属性信息)
 *
 *  @return 当前类的所有属性信息
 */
+ (NSArray *) wProperties;

/**
 *  得到当前类的所有属性,包括从父类继承下来的属性
 *
 *  @param superClass 最上层父类
 *  @param isInclude  是否包含superClass的属性
 *
 *  @return 得到当前类的所有属性,包括从父类继承下来的属性
 */
+ (NSArray *) wPropertiesToSuperClass:(Class)superClass IsIncludeSuperClass:(BOOL)isInclude;

/**
 *  得到属性信息
 *
 *  @param name 属性名
 *
 *  @return 属性信息
 */
+ (WRTProperty *)wPropertyForName:(NSString *)name;




@end



