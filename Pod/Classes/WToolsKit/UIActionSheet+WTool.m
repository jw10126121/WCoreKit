//
//  UIActionSheet+WTool.m
//
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIActionSheet+WTool.h"
#import <objc/runtime.h>

const char kPropertyIdentificationKey_MyDelegateActionSheet;
const char kPropertyIdentificationKey_CompletionHandlerKeyActionSheet;

@implementation UIActionSheet (WTool)
-(void)wSetClickedBtnCBK:(void (^)(NSInteger))wClickedBtnCBK
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self wSaveOldDelegate];
    sheet.delegate = self;
    objc_setAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKeyActionSheet, wClickedBtnCBK, OBJC_ASSOCIATION_COPY);
}

-(void)wSaveOldDelegate
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    id oldDelegate = sheet.delegate;
    if (oldDelegate)
    {
        objc_setAssociatedObject(self, &kPropertyIdentificationKey_MyDelegateActionSheet, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

-(void (^)(NSInteger))wClickedBtnCBK
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKeyActionSheet);
    return theCompletionHandler;
}
/*
#pragma mark -
const char kPropertyIdentificationKey_wAdditionalProperty;
-(void)wSetAdditionalProperty:(id)wAdditionalProperty
{
    objc_setAssociatedObject(self,&kPropertyIdentificationKey_wAdditionalProperty,wAdditionalProperty,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)wAdditionalProperty
{
    return objc_getAssociatedObject(self,&kPropertyIdentificationKey_wAdditionalProperty);
}
*/
#pragma mark -
-(void)wShowWithView:(UIView *)aView CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet * sheet = (UIActionSheet *)self;
    [self wSaveHandler:completionHandler];
    [sheet showInView:aView];
}

-(void)wShowFromTabBar:(UITabBar *)aTabBar CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet * sheet = (UIActionSheet *)self;
    [self wSaveHandler:completionHandler];
    [sheet showFromTabBar:aTabBar];
}

-(void)wShowFromToolbar:(UIToolbar *)aToolbar CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet * sheet = (UIActionSheet *)self;
    [self wSaveHandler:completionHandler];
    [sheet showFromToolbar:aToolbar];
}

-(void)wShowFromBarButtonItem:(UIBarButtonItem *)aBarItem
                     Animated:(BOOL)animated
                CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet * sheet = (UIActionSheet *)self;
    [self wSaveHandler:completionHandler];
    [sheet showFromBarButtonItem:aBarItem animated:animated];
}

-(void)wShowFromRect:(CGRect)rect
              InView:(UIView *)view
            Animated:(BOOL)animated
       CompletionCBK:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet * sheet = (UIActionSheet *)self;
    [self wSaveHandler:completionHandler];
    [sheet showFromRect:rect inView:view animated:animated];
}

-(void)wSaveHandler:(void(^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self wSaveOldDelegate];
    sheet.delegate = self;
    objc_setAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKeyActionSheet, completionHandler, OBJC_ASSOCIATION_COPY);
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &kPropertyIdentificationKey_CompletionHandlerKeyActionSheet);
    if(theCompletionHandler)
    {
        theCompletionHandler(buttonIndex);
    }
    UIActionSheet *sheet = (UIActionSheet *)self;
    sheet.delegate = objc_getAssociatedObject(self, &kPropertyIdentificationKey_MyDelegateActionSheet);
    if (sheet.delegate
        && [sheet.delegate conformsToProtocol:@protocol(UIActionSheetDelegate)]
        && [sheet.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [sheet.delegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}

@end
