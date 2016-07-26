//
//  WAuthorizationManager.m
//
//  Created by Linjw on 16/7/26.
//  Copyright © 2016年 Linjw. All rights reserved.
//


#import "WAuthorizationManager.h"
#import <Photos/Photos.h>  //#IOS8之后才能用

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import <AssetsLibrary/AssetsLibrary.h>
#pragma clang diagnostic pop

#define UsePhotoKit __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0


@interface WAuthorizationManager ()

@property (nonatomic, copy) void(^checkAuthorizationCompletion)(WPhotoAuthStatus status);


@end


@implementation WAuthorizationManager

- (void)checkAuthorizationStatus:(void(^)(WPhotoAuthStatus status))completion
{
    self.checkAuthorizationCompletion = completion;
    if (UsePhotoKit) {
        [self checkAuthorizationStatus_AfteriOS8];
    }else{
        [self checkAuthorizationStatus_BeforeiOS8];
    }
}


- (void)requestAuthorization
{
    if (UsePhotoKit) {
        [self requestAuthorizationStatus_AfteriOS8];
    }else{
        [self requestAuthorizationStatus_BeforeiOS8];
    }
}

- (void)checkAuthorizationStatus_AfteriOS8
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
            [self requestAuthorizationStatus_AfteriOS8];
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self showAccessDenied];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            [self checkAuthorizationSuccess];
            break;
        }
    }
}

- (void)requestAuthorizationStatus_AfteriOS8
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    [self checkAuthorizationSuccess];
                    break;
                }
                default:
                {
                    [self showAccessDenied];
                    break;
                }
            }
        });
    }];
}

- (void)checkAuthorizationStatus_BeforeiOS8
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status)
    {
        case ALAuthorizationStatusNotDetermined:
            [self requestAuthorizationStatus_AfteriOS8];
            break;
        case ALAuthorizationStatusRestricted:
        case ALAuthorizationStatusDenied:
        {
            [self showAccessDenied];
            break;
        }
        case ALAuthorizationStatusAuthorized:
        default:
        {
            [self checkAuthorizationSuccess];
            break;
        }
    }
#pragma clang diagnostic pop
}

- (void)requestAuthorizationStatus_BeforeiOS8
{
    //do nothing
}

- (void)checkAuthorizationSuccess
{
    if (self.checkAuthorizationCompletion) {
        self.checkAuthorizationCompletion(WPhotoAuthStatusSuccess);
    }
}

- (void)showAccessDenied
{
    if (self.checkAuthorizationCompletion) {
        self.checkAuthorizationCompletion(WPhotoAuthStatusAccessDenied);
    }
}

- (void)showNoAssets
{
    if (self.checkAuthorizationCompletion) {
        self.checkAuthorizationCompletion(WPhotoAuthStatusNoAssets);
    }
}

@end







