//
//  UIColor+WTool.m
//  Cha4OnLine
//
//  Created by linjiawei on 14-7-7.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIColor+WTool.h"

@implementation UIColor (WTool)

#pragma mark - UIColor

/**
 *  通过16进制获取颜色
 */
UIColor * wColorWithHexValue(NSInteger hexValue,CGFloat alphaValue)
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

/**
 *  通过16进制获取颜色
 */
UIColor * wColorWithHexStrA(NSString * hexStr,CGFloat alphaValue)
{
    NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor blackColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alphaValue];
}

UIColor * wColorWithHexStr(NSString * hexStr)
{
    return wColorWithHexStrA(hexStr, 1.0);
}

/**
 *  通过RGB与透明度获取颜色
 */
UIColor * wColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
    
    return color;
}

UIColor * wColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return wColorWithRGBA(red, green, blue, 1.0);
}

/**
 *  随机颜色
 */
UIColor * wRandomColor()
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        // srandom()这个函数是初始化随机数产生器
        srandom((unsigned)time(NULL));
    }
    // random()函数产生随即值
    CGFloat red   = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue  = (CGFloat)random() / (CGFloat)RAND_MAX;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


+ (instancetype)wColorWithHexStr:(NSString *)hexStr;
{
	NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor blackColor];
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

/**
 *  获取暗色
 */
- (UIColor *)wColorByDarkeningColorWithValue:(CGFloat)aValue {
    NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
    
    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
    CGFloat newComponents[4];
    
    if (isGreyscale) {
        newComponents[0] = oldComponents[0] - aValue < 0.0f ? 0.0f : oldComponents[0] - aValue;
        newComponents[1] = oldComponents[0] - aValue < 0.0f ? 0.0f : oldComponents[0] - aValue;
        newComponents[2] = oldComponents[0] - aValue < 0.0f ? 0.0f : oldComponents[0] - aValue;
        newComponents[3] = oldComponents[1];
    }
    else {
        newComponents[0] = oldComponents[0] - aValue < 0.0f ? 0.0f : oldComponents[0] - aValue;
        newComponents[1] = oldComponents[1] - aValue < 0.0f ? 0.0f : oldComponents[1] - aValue;
        newComponents[2] = oldComponents[2] - aValue < 0.0f ? 0.0f : oldComponents[2] - aValue;
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *retColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    
    return retColor;
}


@end
