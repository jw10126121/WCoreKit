//
//  WAlertAction.m
//  WAlertController
//
//  Created by linjiawei on 15/12/3.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import "WAlertAction.h"




@interface WAlertAction ()






@end

@implementation WAlertAction

+ (id)actionWithTitle:(nullable NSString *)title style:(WAlertActionStyle)style handler:(void (^ __nullable)(WAlertAction *))handler
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
        {
        UIAlertActionStyle actionStyle = (NSInteger)style;
        
        return [UIAlertAction actionWithTitle:title style:actionStyle handler:(void (^ __nullable)(UIAlertAction *))handler];
    }
    else
    {
        WAlertAction *action = [[WAlertAction alloc] init];
        action->_title = title;
        action->_style = style;
        action.handler = handler;
        action.enabled = YES;
        return action;
    }
}
@end



