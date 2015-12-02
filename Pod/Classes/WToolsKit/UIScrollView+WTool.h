//
//  UIScrollView+WTool.h
//
//
//  Created by Linjw on 14-4-3.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WTool)

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
*/

/** YES if the scrollView's offset is at the very top. */
@property (nonatomic, readonly) BOOL wIsAtTop;
/** YES if the scrollView's offset is at the very bottom. */
@property (nonatomic, readonly) BOOL wIsAtBottom;
/** YES if the scrollView can scroll from it's current offset position to the bottom. */
@property (nonatomic, readonly) BOOL wCanScrollToBottom;

/** The vertical scroll indicator view. */
@property (nonatomic, readonly) UIView *wVerticalScroller;
/** The horizontal scroll indicator view. */
@property (nonatomic, readonly) UIView *wHorizontalScroller;

/**
 Sets the content offset to the top.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)wScrollToTopAnimated:(BOOL)animated;

/**
 Sets the content offset to the bottom.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)wScrollToBottomAnimated:(BOOL)animated;

/**
 Stops scrolling, if it was scrolling.
 */
- (void)wStopScrolling;

@end
