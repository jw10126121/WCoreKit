//
//  UIAlertView+WTool.m
//
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIAlertView+WTool.h"
#import <objc/runtime.h>

const char kPropertyIdentificationKey_MyDelegate;//代理
const char kPropertyIdentificationKey_CompletionHandlerKey;//完成后的回调
//const char kPropertyIdentificationKey_wAdditionalProperty;//额外属性

@implementation UIAlertView (WTool)

//@property(nonatomic,copy,setter = wSetCompletionCBK:)void(^wCompletionCBK)(NSInteger btnIndex);
-(void)wSetClickedBtnCBK:(void (^)(NSInteger))wCompletionCBK
{
    UIAlertView * alert = (UIAlertView *)self;
    //保存旧的代理
    [self wSaveOldDelegate];
    //设置新的代理为当前自身
    alert.delegate = self;
    objc_setAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKey, wCompletionCBK, OBJC_ASSOCIATION_COPY);
}

-(void (^)(NSInteger))wClickedBtnCBK
{
    //得到Block
   return objc_getAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKey);

}

/*
-(void)wSetAdditionalProperty:(id)wAdditionalProperty
{
    objc_setAssociatedObject(self,&kPropertyIdentificationKey_wAdditionalProperty,wAdditionalProperty,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)wAdditionalProperty
{
    return objc_getAssociatedObject(self,&kPropertyIdentificationKey_wAdditionalProperty);
}
*/

-(void)wSaveOldDelegate
{
    UIAlertView * alert = (UIAlertView *)self;
    //把旧的代理保存起来
    id oldDelegate = alert.delegate;
    if(oldDelegate)
    {
        //保存代理
        objc_setAssociatedObject(self, &kPropertyIdentificationKey_MyDelegate, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

-(void)wShowWithCompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIAlertView * alert = (UIAlertView *)self;
    if(completionHandler)
    {
        //保存旧的代理
        [self wSaveOldDelegate];
        //设置新的代理为当前自身
        alert.delegate = self;
        objc_setAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    //得到Block
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKey);
    if(theCompletionHandler)
    {
        theCompletionHandler(buttonIndex);
    }
    
    
    //还原代理并执行原来代理的代理方法
    alert.delegate = objc_getAssociatedObject(self, &kPropertyIdentificationKey_MyDelegate);
    if (alert.delegate &&
        [alert.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)] &&
        [alert.delegate conformsToProtocol:@protocol(UIAlertViewDelegate)])
    {
        [alert.delegate alertView:alert clickedButtonAtIndex:buttonIndex];
    }
}


@end
