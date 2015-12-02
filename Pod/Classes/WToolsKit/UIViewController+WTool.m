//
//  UIViewController+WTool.m
//
//
//  Created by Linjw on 13-11-29.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//



#import "UIViewController+WTool.h"

#import <objc/runtime.h>

#define WtoolSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IsIos7OrLater (WtoolSystemVersion >= 7.0)
#define IsIos8OrLater (WtoolSystemVersion >= 8.0)
#define IsBeforeIOS7 (WtoolSystemVersion < 7.0)
#define SDKIsOrLaterForIOS7_UIViewController (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
#define SDKIsOrLaterForIOS5_UIViewController (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
#define SDKIsRunInARC_UIViewController_WTool (__has_feature(objc_arc))
#define SDKIsRunInMRC_UIViewController_WTool (!__has_feature(objc_arc))

NSString const * __UINavigationBarWCustomHeightHeightKey = @"__UINavigationBarWCustomHeightHeightKey__";
NSString const * __NavBackBtnWillBackBlkKey__ = @"__NavBackBtnWillBackBlkKey__";
NSString const * __NavBackBtnDoneBackBlkKey__ = @"__NavBackBtnDoneBackBlkKey__";

@implementation UIViewController (WTool)


#pragma mark - 把导航条的旋转方向与他的topViewController保持一致
- (BOOL)shouldAutorotate
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
        return nav.topViewController.shouldAutorotate;
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
        return nav.topViewController.supportedInterfaceOrientations;
    }
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - NavigationController Or NavigationBar

-(void)wSetNavHiden:(BOOL)wNavHiden {
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
        nav.navigationBarHidden = wNavHiden;
    }else
    {
        self.navigationController.navigationBarHidden = wNavHiden;
    }
}

-(BOOL)wNavHiden {
    BOOL navHiden = NO;
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
        navHiden = nav.navigationBarHidden;
    }else
    {
        navHiden = self.navigationController.navigationBarHidden;
    }
    return navHiden;
}


-(void)wSetNavBackIndicatorImageAfterIos7:(UIImage *)aImage
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
#if SDKIsOrLaterForIOS7_UIViewController
    if (ios7_Or_Later)
    {
        [self.navigationController.navigationBar setBackIndicatorImage:aImage];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:aImage];
    }
#endif
}

//设置导航条Appear返回按钮的图标(iOS7以上有效)
+(void)wSetAppearNavBackIndicatorImageAfterIos7:(UIImage *)aImage
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
#if SDKIsOrLaterForIOS7_UIViewController
    if (ios7_Or_Later){
        [[UINavigationBar appearance] setBackIndicatorImage:aImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:aImage];
    }
#endif
}

/**
 *  加导航条左按钮自动实现返回方法
 *
 *  @param backBtn 左按钮
 */
-(void)wSetNavButtonToBack:(UIButton *)backBtn
{
    if (backBtn)
    {
        [self wSetNavLeftButton:backBtn];
        [backBtn addTarget:self action:@selector(wBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)wBackBtnAction:(UIButton *)btn
{
    void(^NavBackBtnWillBackBlk__)(void) = objc_getAssociatedObject(self, &__NavBackBtnWillBackBlkKey__);
    void(^NavBackBtnDoneBackBlk__)(void) = objc_getAssociatedObject(self, &__NavBackBtnDoneBackBlkKey__);
    
    if (NavBackBtnWillBackBlk__) {
        NavBackBtnWillBackBlk__();
    }
    
    if (self.navigationController && self.navigationController.viewControllers.count>1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    if (NavBackBtnDoneBackBlk__) {
        NavBackBtnDoneBackBlk__();
    }
}


-(void)wSetNavButtonToBack:(UIButton *)backBtn
                  WillBack:(void(^)())willBackBlk
                  DoneBack:(void(^)())doneBackBlk {
    if (backBtn) {
        objc_setAssociatedObject(self, &__NavBackBtnWillBackBlkKey__, willBackBlk, OBJC_ASSOCIATION_COPY);
        [backBtn addTarget:self action:@selector(wBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, &__NavBackBtnDoneBackBlkKey__, doneBackBlk, OBJC_ASSOCIATION_COPY);
    }
}

-(void)wSetNavLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    //ios7 自定义Leftbarbuttonitem 10px的偏移纠正
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
        negativeSpacer.width = -12;
        if (leftBarButtonItem) {
            self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftBarButtonItem];
        }else{
            self.navigationItem.leftBarButtonItems = @[negativeSpacer];
        }
    }else
    {
        negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [negativeSpacer release];
#endif
}

//加导航条返回按钮
-(void)wSetNavLeftButton:(UIButton *)btnBack
{
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self wSetNavLeftBarButtonItem:leftItem];
#if SDKIsRunInMRC_UIViewController_WTool
    [leftItem release];
#endif
}


-(void)wSetNavRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
        negativeSpacer.width = - 12;
        if (rightBarButtonItem) {
            self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarButtonItem];
        }else
        {
            self.navigationItem.rightBarButtonItems = @[negativeSpacer];
            
        }
    } else
    {
        negativeSpacer.width = 0;
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [negativeSpacer release];
#endif
}

/**
 *  加导航条右按钮
 *
 *  @param rightBtn 右按钮
 */
-(void)wSetNavRightButton:(UIButton *)rightBtn
{
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self wSetNavRightBarButtonItem:rightItem];
#if SDKIsRunInMRC_UIViewController_WTool
    [rightItem release];
#endif
}

-(void)wSetNavRightBarBtnItems:(NSArray *)btnItems
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
        negativeSpacer.width = - 12;
        if (btnItems.count) {
            NSMutableArray * arr = [[NSMutableArray alloc] init];
            [arr addObject:negativeSpacer];
            [arr addObjectsFromArray:btnItems];
            self.navigationItem.rightBarButtonItems = arr;
#if SDKIsRunInMRC_UIViewController_WTool
            [arr release];
#endif
        }else
        {
            self.navigationItem.rightBarButtonItems = @[negativeSpacer];
        }
    } else
    {
        negativeSpacer.width = 0;
        self.navigationItem.rightBarButtonItems = btnItems;
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [negativeSpacer release];
#endif
}

-(void)wSetNavRightBtns:(NSArray *)btns
{
    NSMutableArray * items = [[NSMutableArray alloc]initWithCapacity:btns.count];
    for (id tempId in btns)
    {
        if ([tempId isKindOfClass:[UIButton class]])
        {
            UIButton * btn = (UIButton *)tempId;
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
            [items addObject:item];
#if SDKIsRunInMRC_UIViewController_WTool
            [item release];
#endif
        }
    }
    
    NSMutableArray * theItems = [[NSMutableArray alloc]initWithArray:[[items reverseObjectEnumerator] allObjects]];
#if SDKIsRunInMRC_UIViewController_WTool
    [items release];
#endif
    [self wSetNavRightBarBtnItems:theItems];
#if SDKIsRunInMRC_UIViewController_WTool
    [theItems release];
#endif
    
}

//是否开启强烈的毛玻璃
-(void)wSetNavBarTranslucent:(BOOL)Translucent {
    if ([self isKindOfClass:[UINavigationController class]])  {
        UINavigationController * nav = (UINavigationController *)self;
        nav.navigationBar.translucent = Translucent;
    }else
    {
        self.navigationController.navigationBar.translucent = Translucent;
    }
}

-(BOOL)wNavBarTranslucent
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
       return nav.navigationBar.translucent;
    }else
    {
       return self.navigationController.navigationBar.translucent;
    }
}

//设置导航条标题信息
+(void)wSetAppearNavInfoWithTextColor:(UIColor *)textColor
                                 Font:(UIFont *)textFont
                           TextShadow:(NSShadow *)shadow
{
    if (!textFont && !textColor && !shadow) {
        return;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    NSMutableDictionary * dicAttributes = [[NSMutableDictionary alloc] init];
    if (textColor) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor;
#pragma clang diagnostic pop
#else
        key = UITextAttributeTextColor;
#endif
        [dicAttributes setObject:textColor forKey:key];
    }
    
    if (textFont) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSFontAttributeName:UITextAttributeFont;
#pragma clang diagnostic pop
#else
        key = UITextAttributeFont;
#endif
        [dicAttributes setObject:textFont forKey:key];
    }
    
    if (shadow) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSShadowAttributeName:UITextAttributeTextShadowColor;
#pragma clang diagnostic pop
#else
        key = UITextAttributeTextShadowColor;
#endif
        [dicAttributes setObject:shadow forKey:key];
        
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:dicAttributes];
#if SDKIsRunInMRC_UIViewController_WTool
    [dicAttributes release];
#endif
}

-(void)wSetNavInfoWithTextColor:(UIColor *)textColor
                           Font:(UIFont *)textFont
                     TextShadow:(NSShadow *)shadow {
    if (!textFont && !textColor && !shadow) {
        return;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    NSMutableDictionary * dicAttributes = [[NSMutableDictionary alloc] init];
    if (textColor) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor;
#pragma clang diagnostic pop
#else
        key = UITextAttributeTextColor;
#endif
        [dicAttributes setObject:textColor forKey:key];
    }
    
    if (textFont) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSFontAttributeName:UITextAttributeFont;
#pragma clang diagnostic pop
#else
        key = UITextAttributeFont;
#endif
        [dicAttributes setObject:textFont forKey:key];
    }
    
    if (shadow) {
        NSString * key = @"";
#if SDKIsOrLaterForIOS7_UIViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        key = ios7_Or_Later?NSShadowAttributeName:UITextAttributeTextShadowColor;
#pragma clang diagnostic pop
#else
        key = UITextAttributeTextShadowColor;
#endif
        [dicAttributes setObject:shadow forKey:key];
        
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)self;
        [nav.navigationBar setTitleTextAttributes:dicAttributes];
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:dicAttributes];
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [dicAttributes release];
#endif
}

/**
 *  设置导航条颜色
 *
 *  @param tintColor aColor
 */
-(void)wSetNavBarTintColor:(UIColor *)tintColor{
    if (!tintColor) {
        return;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController *)self;
        if (ios7_Or_Later)
        {
#if SDKIsOrLaterForIOS7_UIViewController
            nav.navigationBar.barTintColor = tintColor;
#else
            nav.navigationBar.tintColor = tintColor;
#endif
        }
        else
        {
            nav.navigationBar.tintColor = tintColor;
        }
    }
}

+(void)wSetAppearNavBarTintColor:(UIColor *)aColor
{
    if (!aColor) {
        return;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later) {
#if SDKIsOrLaterForIOS7_UIViewController
        [[UINavigationBar appearance] setBarTintColor:aColor];
#else
        [[UINavigationBar appearance] setTintColor:aColor];
#endif
    }else{
        [[UINavigationBar appearance] setTintColor:aColor];
    }
}

/**
 *  设置导航条背景色
 */
-(void)wSetNavBarBackGroundImgColor:(UIColor *)aColor {
    if (aColor) {
        UINavigationController * nav;
        if ([self isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)self;
        }else {
            nav = self.navigationController;
        }
        UIImage * backImg = [UIViewController __wImageWithColor:aColor CornerRadius:0 Size:(CGSize){1,1}];
        [nav.navigationBar setBackgroundImage:backImg forBarMetrics:UIBarMetricsDefault];
        
    }
}

+ (UIImage *)__wImageWithColor:(UIColor *)aColor CornerRadius:(CGFloat)cornerRadius Size:(CGSize)aSize
{
    CGFloat width = MAX(aSize.width, cornerRadius*2+1);
    CGFloat height = MAX(aSize.height, cornerRadius*2+1);
    CGRect rect = CGRectMake(0, 0, width, height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [aColor setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

//是否开启右滑返回(ios7)
-(void)wSetRightSlidingToBackAfterIos7:(BOOL)isSlidingToBack
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        if ([self isKindOfClass:[UINavigationController class]])
        {
            UINavigationController  * nav = (UINavigationController *)self;
            nav.interactivePopGestureRecognizer.enabled = isSlidingToBack;
        }else
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = isSlidingToBack;
        }
#endif
    }
}

#pragma mark - UITabBarController Or UITabBar
/**
 *  设置TabBarItem信息
 *  @param aTextColorNL 正常颜色
 *  @param aTextColorSL 选中颜色
 *  @param aImgNL 正常图片
 *  @param aImgSL 选中图片
 */
-(void)wSetTabBarItemWithTextColorNL:(UIColor *)aTextColorNL
                         TextColorSL:(UIColor *)aTextColorSL
                               ImgNL:(UIImage *)aImgNL
                               ImgSL:(UIImage *)aImgSL
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    
#if SDKIsOrLaterForIOS7_UIViewController//SDK7.0之后才有的方法
    if (IsIos7OrLater) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.tabBarItem setFinishedSelectedImage:aImgSL
                      withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
        UITabBarItem * itemNew = [self.tabBarItem initWithTitle:self.tabBarItem.title
                                                          image:aImgNL
                                                  selectedImage:aImgSL];//SDK7.0之后才有的方法
        self.tabBarItem = itemNew;
#pragma clang diagnostic pop
#if SDKIsRunInMRC_UIViewController_WTool
        [itemNew release];
#endif
    }else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.tabBarItem setFinishedSelectedImage:aImgSL
                      withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
#pragma clang diagnostic pop
    }
#else
    [self.tabBarItem setFinishedSelectedImage:aImgSL
                  withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
#endif
    
    NSMutableDictionary * dicNL = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dicSL = [[NSMutableDictionary alloc] init];
    if (aTextColorNL)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicNL setObject:aTextColorNL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        if (self.tabBarItem)
        {
            [self.tabBarItem setTitleTextAttributes:dicNL forState:UIControlStateNormal];
        }
    }
    
    if (aTextColorSL)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicSL setObject:aTextColorSL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        if (self.tabBarItem)
        {
            [self.tabBarItem setTitleTextAttributes:dicSL forState:UIControlStateSelected];
        }
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [dicNL release];
    [dicSL release];
#endif
    
}

+(void)wSetAppearTabBarItemWithTextColorNL:(UIColor *)aTextColorNL
                               TextColorSL:(UIColor *)aTextColorSL
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    NSMutableDictionary * dicNL = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dicSL = [[NSMutableDictionary alloc] init];
    if (aTextColorNL)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicNL setObject:aTextColorNL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        [[UITabBarItem appearance] setTitleTextAttributes:dicNL forState:UIControlStateNormal];
    }
    
    if (aTextColorSL)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicSL setObject:aTextColorSL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        [[UITabBarItem appearance] setTitleTextAttributes:dicSL forState:UIControlStateSelected];
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [dicNL release];
    [dicSL release];
#endif
}

/**
 *  设置TabbarItem颜色(正常颜色,选中颜色)
 */
-(void)wSetTabBarItemWithTextColorNL:(UIColor *)aTextColorNL
                         TextColorSL:(UIColor *)aTextColorSL
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (aTextColorNL)
    {
        NSMutableDictionary * dicNL = [[NSMutableDictionary alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicNL setObject:aTextColorNL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        [self.tabBarItem setTitleTextAttributes:dicNL forState:UIControlStateNormal];
    }
    
    if (aTextColorSL)
    {
        NSMutableDictionary * dicSL = [[NSMutableDictionary alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [dicSL setObject:aTextColorSL forKey:ios7_Or_Later?NSForegroundColorAttributeName:UITextAttributeTextColor];
#pragma clang diagnostic pop
        [self.tabBarItem setTitleTextAttributes:dicSL forState:UIControlStateSelected];
    }
#if SDKIsRunInMRC_UIViewController_WTool
    [dicNL release];
    [dicSL release];
#endif
}

-(void)wSetTabBarItemWithImgNL:(UIImage *)aImgNL
                         ImgSL:(UIImage *)aImgSL
{
#if SDKIsOrLaterForIOS7_UIViewController//SDK7.0之后才有的方法
    if (IsIos7OrLater) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (IsIos8OrLater) {
            aImgSL = [aImgSL imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            aImgNL = [aImgNL imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        //        [self.tabBarItem setFinishedSelectedImage:aImgSL
        //                      withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
        
        UITabBarItem * itemNew = [self.tabBarItem initWithTitle:self.tabBarItem.title
                                                          image:aImgNL
                                                  selectedImage:aImgSL];//SDK7.0之后才有的方法
#pragma clang diagnostic pop
        self.tabBarItem = itemNew;
#if SDKIsRunInMRC_UIViewController_WTool
        [itemNew release];
#endif
        
    }else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.tabBarItem setFinishedSelectedImage:aImgSL
                      withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
#pragma clang diagnostic pop
    }
#else
    [self.tabBarItem setFinishedSelectedImage:aImgSL
                  withFinishedUnselectedImage:aImgNL];//SDK5.0之后的方法
#endif
}

/**
 *  背景色
 *
 *  @param aColor 背景色
 */
-(void)wSetTabBarTintColor:(UIColor *)aColor
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        if ([self isKindOfClass:[UITabBarController class]])
        {
            UITabBarController * tabBarC = (UITabBarController *)self;
            [tabBarC.tabBar setBarTintColor:aColor];
        }else
        {
            [self.tabBarController.tabBar setBarTintColor:aColor];
        }
#else
        [self.tabBarController.tabBar setTintColor:aColor];
#endif
    }else
    {
        if ([self isKindOfClass:[UITabBarController class]])
        {
            UITabBarController * tabBarC = (UITabBarController *)self;
            [tabBarC.tabBar setTintColor:aColor];
        }else
        {
            [self.tabBarController.tabBar setTintColor:aColor];
        }
    }
}

#pragma mark - Other
//是否开启ScrollView可以滚动整个屏幕(ios7)
-(void)wSetScrollFullScreenAfterIos7:(BOOL)FullScreen {
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        self.automaticallyAdjustsScrollViewInsets = FullScreen;
#endif
    }
    //     if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    //         self.automaticallyAdjustsScrollViewInsets = FullScreen;
    //     }
}

-(BOOL)wIsScrollFullScreenAfterIos7
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    BOOL isFullScreen = NO;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        isFullScreen = self.automaticallyAdjustsScrollViewInsets;
#endif
    }
    return isFullScreen;
}

//是否开启全屏布局(ios7)
-(void)wSetFullScreenAfterIos7:(BOOL)FullScreen
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
        if (!FullScreen)
        {
#if SDKIsOrLaterForIOS7_UIViewController
            self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
        }
    }
}

/**
 *  是否视图内容自动调整至全屏(默认YES)
 */
-(BOOL)wIsFullScreenAfterIos7
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    BOOL FullScreen = NO;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
            FullScreen = (self.edgesForExtendedLayout == UIRectEdgeAll);
#endif
    }
    return FullScreen;
}

-(void)wSetEdgeForExtendedLayoutAfterIos7:(UIRectEdge)aRectEdge
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        self.edgesForExtendedLayout = aRectEdge;
#endif
    }
}

//设置状态栏透明
-(void)wIsOpaqueBarsToExtendedLayoutAfterIos7:(BOOL)isOpaque
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        self.extendedLayoutIncludesOpaqueBars = isOpaque;
#endif
    }
}

//子视图向下偏移20像素(IOS7)
-(CGFloat)wIsBoundsIos6ToIos7:(BOOL)isMove
{
    CGFloat sbar = 0.0;
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later) {
        sbar = [self wIsSubViewMoveDown20:isMove];
    }
    return sbar;
}

-(CGFloat)wIsBoundsIos7ToIos6:(BOOL)isMove
{
    CGFloat sbar = 0.0;
    BOOL ios7_Before = [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0;
    if (isMove) {
        if (ios7_Before) {
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
            {
                sbar = [UIApplication sharedApplication].statusBarFrame.size.height;
            }else
            {
                sbar = [UIApplication sharedApplication].statusBarFrame.size.width;
            }
            self.view.bounds = CGRectMake(0, sbar, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    return sbar;
}

//子视图向下偏移20像素
-(CGFloat)wIsSubViewMoveDown20:(BOOL)isMove
{
    CGFloat sbar = 0.0;
    if (isMove) {
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        {
            sbar = [UIApplication sharedApplication].statusBarFrame.size.height;
        }else
        {
            sbar = [UIApplication sharedApplication].statusBarFrame.size.width;
        }
    }else{
        sbar = 0.0;
    }
    self.view.bounds = CGRectMake(0, - sbar, self.view.frame.size.width, self.view.frame.size.height + sbar);
    return sbar;
}


CGRect	wCGRectMake_Ios7ToIos6( CGFloat x, CGFloat y, CGFloat w, CGFloat h )
{
    CGFloat sbar = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        sbar = [UIApplication sharedApplication].statusBarFrame.size.height;
    }else
    {
        sbar = [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    return CGRectMake(x, y - (ios7_Or_Later?0:sbar), w, h - (ios7_Or_Later?0:sbar));
}




/**
 *  当系统为IOS6且自带的导航条没显示时，把当前视图的子视图坐标上移20像素.
 *  坐标上移,相当于视图下移
 *  @return 坐标上移的像素值
 */
-(CGFloat)wBoundsIos7ToIos6WhenNavHidenWithNavStyle:(BOOL)isNavStyleIOS7;
{
    CGFloat h = 0.0;
    if (!self.navigationController ||
        !self.navigationController.navigationBar ||
        self.navigationController.isNavigationBarHidden)
    {
        if (isNavStyleIOS7)
        {
            h = [self wIsBoundsIos7ToIos6:YES];
        }else
        {
            h = [self wIsBoundsIos6ToIos7:YES];
        }
    }
    return h;
}

-(CGFloat)wTopOfViewOffset
{
    CGFloat top = 0;
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        top = self.topLayoutGuide.length;
#endif
    }
    return top;
}

/**
 *  结束编辑
 */
-(void)wEndEditing
{
    [self.view endEditing:YES];
}

+(void)wEndEditingForKeyWindow
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}



#pragma mark - UIPopoverViewController

-(void)wSetPreferredContentSize:(CGSize)aPreferredContentSize
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        self.preferredContentSize = aPreferredContentSize;
#endif
    }else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.contentSizeForViewInPopover = aPreferredContentSize;
#pragma clang diagnostic pop
    }
}

-(CGSize)wPreferredContentSize
{
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    CGSize size = CGSizeZero;
    if (ios7_Or_Later)
    {
#if SDKIsOrLaterForIOS7_UIViewController
        size = self.preferredContentSize;
#endif
    }else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = self.contentSizeForViewInPopover;
#pragma clang diagnostic pop
    }
    return size;
}




@end


@implementation UITabBarController (WTool)

/*!
 *  设置TabBar背景图
 *
 *  @param aImage TabBar背景图
 */
-(void)wSetTabBarBackgroundImg:(UIImage *)aImage
{
#if SDKIsOrLaterForIOS5_UIViewController
    [self.tabBar setBackgroundImage:aImage];
#else
    NSLog(@"IOS5下UITabBar不能使用setBackgroundImage方法");
#endif
}







@end








