//
//  UIColor+WTool.h
//  Cha4OnLine
//
//  Created by linjiawei on 14-7-7.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (WTool)

#pragma mark - UIColor

/**
 *  通过16进制获取颜色
 */
UIColor * wColorWithHexValue(NSInteger hexValue,CGFloat alphaValue);
UIColor * wColorWithHexStrA(NSString * hexStr,CGFloat alphaValue);
UIColor * wColorWithHexStr(NSString * hexStr);

/**
 *  通过RGB与透明度获取颜色
 */
UIColor * wColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
UIColor * wColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

/**
 *  随机颜色
 */
UIColor * wRandomColor();

/**
 *  16进制Color字符串转UIColor
 *  @param string 16进制Color字符串
 *  @return UIColor
 */
+ (instancetype)wColorWithHexStr:(NSString *)hexStr;

/**
 *  获取暗色
 */
- (UIColor *)wColorByDarkeningColorWithValue:(CGFloat)aValue;





@end
