//
//  NSMutableAttributedString+WTool.m
//  ChatDemo
//
//  Created by linjw on 14-9-11.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//
//  ------------------ Ljw QQ:10126121 ------------------

#import "NSMutableAttributedString+WTool.h"
#import <QuartzCore/QuartzCore.h>
#import "JwDefine.h"


@implementation NSMutableAttributedString (WTool)

/**
 *  设置字体属性
 */
- (void)wSetFont:(UIFont *)font Range:(NSRange)aRange {
    if (font) {
        [self removeAttribute:(NSString*)kCTFontAttributeName range:aRange];
        
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFloat fontSize = font.pointSize;
        CTFontRef ctfont = CTFontCreateWithName(fontName, fontSize, NULL);
        [self addAttributes:@{(id)kCTFontAttributeName: (__bridge id)ctfont} range:aRange];
        CFRelease(ctfont);
    }
}

/**
 *  设置颜色
 */
-(void)wSetForegroundColor:(UIColor *)aColor Range:(NSRange)aRange {
    if (aColor) {
        //        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:aRange];
        //        [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)aColor.CGColor range:aRange];
        [self removeAttribute:(NSString *)NSForegroundColorAttributeName range:aRange];
        [self addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)aColor range:aRange];
        
    }
}

/**
 *  设置下划线
 */
-(void)wSetUnderlineStyle:(CTUnderlineStyle)lineStyle LineColor:(UIColor *)aColor Range:(NSRange)aRange {
    
    
    [self removeAttribute:(NSString *)kCTUnderlineStyleAttributeName range:aRange];
    [self removeAttribute:(NSString *)kCTUnderlineColorAttributeName range:aRange];
    
    [self addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)@(lineStyle) range:aRange];
    [self addAttribute:(id)kCTUnderlineColorAttributeName value:(id)aColor.CGColor range:aRange];
    
}

/**
 *  设置删除线
 */
-(void)wSetThroughLineRange:(NSRange)aRange Color:(UIColor *)aColor
{
    [self addAttribute:NSStrikethroughStyleAttributeName
                 value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                 range:aRange];

    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedDescending)) {
        [self addAttribute:NSStrikethroughColorAttributeName value:aColor range:aRange];
    }
}

/**
 *  设置字体间距
 */
-(void)wSetFontSpace:(NSInteger)space Range:(NSRange)aRange {
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&space);
    [self addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:aRange];
    CFRelease(num);
}

/**
 *  设置空心效果
 */
-(void)wSetStrokeWidth:(CGFloat)width StrokeColor:(UIColor *)aColor Range:(NSRange)aRange {
    
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&width);
    [self addAttribute:(id)kCTStrokeWidthAttributeName value:(__bridge id)num range:aRange];
    CFRelease(num);
    
    [self addAttribute:(id)kCTStrokeColorAttributeName value:(id)aColor.CGColor range:aRange];
}



@end





