//
//  UIScrollView+WTool.m
//
//
//  Created by Linjw on 14-4-3.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIScrollView+WTool.h"
#import <objc/runtime.h>

static NSString * const kKeyScrollViewVerticalIndicator = @"_verticalScrollIndicator";
static NSString * const kKeyScrollViewHorizontalIndicator = @"_horizontalScrollIndicator";



@implementation UIScrollView (WTool)
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}
*/

- (void)wScrollToTopAnimated:(BOOL)animated
{
    if (![self wIsAtTop]) {
        CGPoint bottomOffset = CGPointZero;
        [self setContentOffset:bottomOffset animated:animated];
    }
}

- (void)wScrollToBottomAnimated:(BOOL)animated
{
    if ([self wCanScrollToBottom] && ![self wIsAtBottom]) {
        CGPoint bottomOffset = CGPointMake(0.0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom + self.contentInset.top);
        [self setContentOffset:bottomOffset animated:animated];
    }
    
}

- (BOOL)wIsAtTop
{
    return (self.contentOffset.y == 0.0) ? YES : NO;
}

- (BOOL)wIsAtBottom
{
    CGFloat bottomOffset = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom + self.contentInset.top;
    return (self.contentOffset.y == bottomOffset) ? YES : NO;
}

- (BOOL)wCanScrollToBottom
{
    if (self.contentSize.height + self.contentInset.bottom + self.contentInset.top> self.bounds.size.height) {
        return YES;
    }
    return NO;
}

- (void)wStopScrolling
{
    if (!self.isDragging) {
        return;
    }
    
    CGPoint offset = self.contentOffset;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

- (UIView *)wVerticalScroller
{
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        objc_setAssociatedObject(self, _cmd, [self safeValueForKey:kKeyScrollViewVerticalIndicator], OBJC_ASSOCIATION_ASSIGN);
    }
    
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)wHorizontalScroller
{
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        objc_setAssociatedObject(self, _cmd, [self safeValueForKey:kKeyScrollViewHorizontalIndicator], OBJC_ASSOCIATION_ASSIGN);
    }
    
    return objc_getAssociatedObject(self, _cmd);
}

- (id)safeValueForKey:(NSString *)key
{
    Ivar instanceVariable = class_getInstanceVariable([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]);
    return object_getIvar(self, instanceVariable);
}

@end
