//
//  UIAlertView+WTool.h
//  
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  IOS8之后请使用UIAlertController
 */
@interface UIAlertView (WTool)


@property(nonatomic,copy,setter = wSetClickedBtnCBK:)void(^wClickedBtnCBK)(NSInteger btnIndex);

-(void)wShowWithCompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler;


@end
