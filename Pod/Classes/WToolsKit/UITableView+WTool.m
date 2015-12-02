//
//  UITableView+WTool.m
//
//
//  Created by Linjw on 13-12-2.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "UITableView+WTool.h"

@implementation UITableView (WTool)


- (void)wSetSeparatorInsetZeroWhenIos7
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#endif
}

- (void)wSetLayoutMarginsZeroWhenIos8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

-(void)wSetSectionIndexBackgroundColor:(UIColor *)aColor
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        self.sectionIndexColor = aColor;
    }
    #endif
}

- (void)wSetExtraSeparatorLineHidden
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [self setTableHeaderView:view];
#if (!__has_feature(objc_arc))
    [view release];
#endif
}

@end
