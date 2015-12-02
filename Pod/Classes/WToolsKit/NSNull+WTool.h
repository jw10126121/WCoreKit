//
//  NSNull+WTool.h
//  Worker
//
//  Created by Linjw on 14-4-8.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNull (WTool)

+ (id)idNull;
#pragma mark - 类型转化
- (NSInteger) integerValue;

- (int) intValue;

- (BOOL) boolValue;

- (double) doubleValue;

- (float) floatValue;

- (NSUInteger) unsignedIntegerValue;

- (CGFloat) CGFloatValue;

@end


