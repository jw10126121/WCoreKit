//
//  WOrmManager.h
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOrmProtocol.h"

/**
 *  ORM管理类
 */
@interface WOrmManager : NSObject

/**
 *  得到aWmodel的自有属性信息,以及从实现了<WOrmProtocol>的父类继承下来的属性信息
 *
 *  @param aWmodel 参与ORM的Model
 *
 *  @return 属性信息数组(每个元素为WProperty对象)
 */
- (NSArray *) wPropertiesForWmodel:(id<WOrmProtocol>)aWmodel;
+ (NSArray *) wPropertiesForWmodelClass:(Class<WOrmProtocol>)aWmodelClass;

/**
 *  根据aWmodel生成属性信息NSDictionary
 *
 *  @param aWmodel   参与ORM的Model
 *  @param type      生成字典的类型
 *
 *  @return 根据aWmodel生成属性信息NSDictionary
 */
-(NSMutableDictionary *)wDicForWModel:(id<WOrmProtocol>)aWmodel Type:(NSInteger)type;

/**
 *  为aWmodel设置属性信息
 *
 *  @param aWmodel     参与ORM的Model
 *  @param dicForModel aWmodel的属性信息字典
 *  @param type        生成字典的类型
 *
 *  @return 为aWmodel设置属性信息成功？
 */
- (BOOL) wSetWmodel:(id<WOrmProtocol>)aWmodel DicForModel:(NSDictionary *)dicForModel Type:(NSInteger)type;


/**
 *  得到aWmodel的属性信息
 *
 *  @param aWmodel 参与ORM的Model
 *  @param noNull  是否取不为空的属性信息
 *
 *  @return 得到aWmodel的属性信息
 */
- (NSDictionary *)wDicDescriptionForWmodel:(id<WOrmProtocol>)aWmodel WhenHideNull:(BOOL)noNull;

/**
 *  得到aWmodel的属性信息
 *
 *  @param aWmodelClass 参与ORM的类
 *
 *  @return 得到aWmodel的属性信息
 */
+ (NSString *)wCreatTableForWmodel:(Class<WOrmProtocol>)aWmodelClass;




@end








