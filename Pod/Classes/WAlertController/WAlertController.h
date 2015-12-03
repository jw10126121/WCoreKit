//
//  WAlertController.h
//  WAlertController
//
//  Created by linjiawei on 15/12/3.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAlertAction.h"
#import "UIViewController+WAlertController.h"

typedef NS_ENUM(NSInteger, WAlertControllerStyle) {
    WAlertControllerStyleActionSheet = 0,
    WAlertControllerStyleAlert
} NS_ENUM_AVAILABLE_IOS(7_0);

@interface WAlertController : UIViewController

@property(nonatomic,strong)id adaptiveAlert;
@property(nonatomic,strong)UIViewController * ownerController;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WAlertControllerStyle)preferredStyle;

- (void)addAction:(WAlertAction *)action;




@end





