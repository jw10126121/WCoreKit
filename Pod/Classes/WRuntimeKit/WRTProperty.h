//
//  WRTProperty.h
//  WOrmManager
//
//  Created by linjiawei on 15/8/12.
//  Copyright (c) 2015年 yuntui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPropertyType.h"
#import <objc/runtime.h>



/**
 *  运行时属性模型
 */
@interface WRTProperty : NSObject

@property(nonatomic, copy )NSString * name;  //属性名
@property(nonatomic, copy )NSString * type; //属性类型

-(void)wSetWithCProperty:(objc_property_t)cProperty;





@end



