//
//  _WViewController.m
//  WAlertController
//
//  Created by linjiawei on 15/12/3.
//  Copyright © 2015年 linjw. All rights reserved.
//

#import "UIViewController+WAlertController.h"
#import "WAlertController.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property(nonatomic,strong)WAlertController * wAlertController;


@end

@implementation UIViewController (WAlertController)

-(void)setWAlertController:(WAlertController *)wAlertController
{
    objc_setAssociatedObject(self, &"____wAlertController", wAlertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(WAlertController *)wAlertController
{
    return objc_getAssociatedObject(self, &"____wAlertController");
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(tb_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)tb_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[WAlertController class]]) {
        WAlertController* controller = (WAlertController *)viewControllerToPresent;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//            ((UIAlertController *)controller.adaptiveAlert).view.tintColor = controller.view.tintColor;
            [self tb_presentViewController:controller.adaptiveAlert animated:flag completion:completion];
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

@end




