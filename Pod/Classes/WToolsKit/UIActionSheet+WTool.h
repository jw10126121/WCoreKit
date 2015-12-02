//
//  UIActionSheet+WTool.h
//
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  IOS8之后请使用UIAlertController
 */
@interface UIActionSheet (WTool)<UIActionSheetDelegate>

//完成时的回调
@property(nonatomic,copy,setter = wSetClickedBtnCBK:)void(^wClickedBtnCBK)(NSInteger btnIndex);

#pragma mark - 显示ActionSheet

-(void)wShowWithView:(UIView *)aView
   CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)wShowFromTabBar:(UITabBar *)aTabBar
         CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)wShowFromToolbar:(UIToolbar *)aToolbar
          CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)wShowFromBarButtonItem:(UIBarButtonItem *)aBarItem
                     Animated:(BOOL)animated
                CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)wShowFromRect:(CGRect)aRect
              InView:(UIView *)aView
            Animated:(BOOL)isAnimated
       CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;

@end





