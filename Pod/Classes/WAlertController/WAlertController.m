//
//  WAlertController.m
//  WAlertController
//
//  Created by linjiawei on 15/12/3.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import "WAlertController.h"
#import <objc/runtime.h>

@interface WAlertController ()<UIActionSheetDelegate,UIAlertViewDelegate>

//@property(nonatomic,strong)id adaptiveAlert;
@property(nonatomic,strong)NSMutableArray * actions;

@end

@implementation WAlertController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
        {
            _adaptiveAlert = [[UIAlertController alloc] init];
        }else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            _adaptiveAlert = [[UIActionSheet alloc] init];
            _actions = [NSMutableArray array];
            ((UIActionSheet *)_adaptiveAlert).delegate = self;
#pragma clang diagnostic pop
        }
        [self addObserver:self forKeyPath:@"view.tintColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"view.tintColor"];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WAlertControllerStyle)preferredStyle {
    WAlertController *controller = [[WAlertController alloc] init];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        controller.adaptiveAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)preferredStyle];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        switch (preferredStyle) {
            case WAlertControllerStyleActionSheet: {
                controller.adaptiveAlert = [[UIActionSheet alloc] initWithTitle:title delegate:controller cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                break;
            }
            case WAlertControllerStyleAlert: {
                controller.adaptiveAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:controller cancelButtonTitle:nil otherButtonTitles: nil];
                break;
            }
            default: {
                break;
            }
        }
#pragma clang diagnostic pop
    }
    return controller;
}

- (void)addAction:(WAlertAction *)action
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        [self.adaptiveAlert addAction:(UIAlertAction *)action];
    }
    else
    {
        [self.actions addObject:action];
        NSInteger buttonIndex = [self.adaptiveAlert addButtonWithTitle:action.title];
        UIColor *textColor;
        switch (action.style)
        {
            case WAlertActionStyleDefault: {
                textColor = self.view.tintColor;
                break;
            }
            case WAlertActionStyleCancel: {
                [self.adaptiveAlert setCancelButtonIndex:buttonIndex];
                textColor = self.view.tintColor;
                break;
            }
            case WAlertActionStyleDestructive: {
                if ([self.adaptiveAlert isKindOfClass:[UIActionSheet class]])
                {
                    [self.adaptiveAlert setDestructiveButtonIndex:buttonIndex];
                }
                textColor = [UIColor redColor];
                break;
            }
            default: {
                textColor = self.view.tintColor;
                break;
            }
        }
        //        [((UIButton *)((UIView *)self.adaptiveAlert).subviews.lastObject) setTitleColor:textColor forState:0xFFFFFFFF];
    }
}

#pragma - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    __weak __typeof(self)weakSelf = self;
    WAlertAction * action = self.actions[buttonIndex];
    if (action.handler) {
        action.handler(weakSelf.adaptiveAlert);
    }
}
#pragma clang diagnostic pop


/*


#pragma mark - Method Swizzling

- (void)tb_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[WAlertController class]]) {
        WAlertController* controller = (WAlertController *)viewControllerToPresent;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            ((UIAlertController *)controller.adaptiveAlert).view.tintColor = controller.view.tintColor;
            [self tb_presentViewController:((WAlertController *)viewControllerToPresent).adaptiveAlert animated:flag completion:completion];
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if ([controller.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
                self.wAlertController = controller;
                controller.ownerController = self;
                [controller.adaptiveAlert show];
            }
            else if ([controller.adaptiveAlert isKindOfClass:[UIActionSheet class]]) {
                self.wAlertController = controller;
                controller.ownerController = self;
                [controller.adaptiveAlert showInView:self.view];
            }
#pragma clang diagnostic pop
        }
    }
    else {
        [self tb_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


*/


@end












