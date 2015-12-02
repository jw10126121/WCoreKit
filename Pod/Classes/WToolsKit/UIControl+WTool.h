//
//  UIControl+WTool.h
//  
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  事件处理
 */
@interface UIControl (WTool)

/*!
 *  设置事件处理回调
 *
 *  @param event    事件
 *  @param callback 回调
 */
-(void)wSetEvent:(UIControlEvents)event ControlEventCBK:(void(^)(id sender))callback;

/*!
 *  移除事件
 *
 *  @param event 事件
 */
-(void)wRemoveHandlerForEvent:(UIControlEvents)event;




@end




