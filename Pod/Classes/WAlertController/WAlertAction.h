//
//  WAlertAction.h
//  WAlertController
//
//  Created by linjiawei on 15/12/3.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, WAlertActionStyle) {
    WAlertActionStyleDefault = 0,
    WAlertActionStyleCancel,
    WAlertActionStyleDestructive
} NS_ENUM_AVAILABLE_IOS(7_0);

@interface WAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) WAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@property (nullable,nonatomic,strong) void (^handler)(WAlertAction * _Nonnull);


+ (id)actionWithTitle:(nullable NSString *)title style:(WAlertActionStyle)style handler:(void (^ __nullable)(WAlertAction * action))handler;




@end
NS_ASSUME_NONNULL_END