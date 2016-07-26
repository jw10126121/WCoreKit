//
//  WAuthorizationManager.h
//
//  Created by Linjw on 16/7/26.
//  Copyright © 2016年 Linjw. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, WPhotoAuthStatus)
{
    WPhotoAuthStatusSuccess          = 0,
    WPhotoAuthStatusAccessDenied     = 1,
    WPhotoAuthStatusNoAssets         = 2,
    WPhotoAuthStatusUnknown          = 3,
};

/**
 *  权限管理
 */
@interface WAuthorizationManager : NSObject


- (void)checkAuthorizationStatus:(void(^)(WPhotoAuthStatus status))completion;




@end






