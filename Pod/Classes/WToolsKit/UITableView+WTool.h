//
//  UITableView+WTool.h
//  
//
//  Created by Linjw on 13-12-2.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WTool)

/**
 *  设置分隔线与IOS6保持一样(通过setSeparatorInset:)
 */
- (void)wSetSeparatorInsetZeroWhenIos7;

/**
 *  设置分隔线与IOS6保持一样(通过setLayoutMargins:)
 */
- (void)wSetLayoutMarginsZeroWhenIos8;

/*!
 *  在索引没有被触摸的背景色,默认是白色
 */
-(void)wSetSectionIndexBackgroundColor:(UIColor *)aColor;

/**
 *  设置多余的分割线隐藏
 */
- (void)wSetExtraSeparatorLineHidden;





@end



