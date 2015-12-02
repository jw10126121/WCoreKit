//
//  NSMutableAttributedString+WTool.h
//  WTools
//
//  Created by linjw on 14-9-11.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//
//  ------------------ Ljw QQ:10126121 ------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum : NSUInteger {
    WTextAlignmentLeft,
    WTextAlignmentCenter,
    WTextAlignmentRight
} WTextAlignment;

@interface NSMutableAttributedString (WTool)

/**
 *  设置字体属性
 */
- (void)wSetFont:(UIFont *)font Range:(NSRange)aRange;

/**
 *  设置颜色
 */
-(void)wSetForegroundColor:(UIColor *)aColor Range:(NSRange)aRange;

/**
 *  设置下划线
 */
-(void)wSetUnderlineStyle:(CTUnderlineStyle)lineStyle LineColor:(UIColor *)aColor Range:(NSRange)aRange;

/**
 *  设置删除线
 */
-(void)wSetThroughLineRange:(NSRange)aRange Color:(UIColor *)aColor;

/**
 *  设置字体间距
 */
-(void)wSetFontSpace:(NSInteger)space Range:(NSRange)aRange;

/**
 *  设置空心效果
 */
-(void)wSetStrokeWidth:(CGFloat)width StrokeColor:(UIColor *)aColor Range:(NSRange)aRange;






@end








