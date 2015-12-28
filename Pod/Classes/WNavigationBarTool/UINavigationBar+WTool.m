//
//  WNavigationBarTool.m
//  WNavigationBarTool
//
//  Created by linjiawei on 15/12/25.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import "UINavigationBar+WTool.h"
#import <objc/runtime.h>


@implementation UINavigationBar(WTool)

const char * overlayKey = "__UINavigationBarOverlayKey__";

- (UIView *)overlayView
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlayView:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  @author Linjw
 *
 *  设置自定义背景色
 *
 *  @param backgroundColor 背景色
 */
- (void)wSetBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlayView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayView atIndex:0];
    }
    self.overlayView.backgroundColor = backgroundColor;
}


/**
 *  @author Linjw
 *
 *  还原
 */
- (void)wReset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}


-(void)layoutSubviews {
    [super layoutSubviews];
     self.overlayView.frame = CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20);
    
}






@end
