//
//  UIViewController+WTool.h
//
//
//  Created by Linjw on 13-11-29.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//


/*
 设置状态栏字体颜色的方式:(注意判断IOS7环境)
 第1种:调用 setNeedsStatusBarAppearanceUpdate, 然后重写-(UIStatusBarStyle)preferredStatusBarStyle;
 第2种:在infoPlist里设置View controller-based status bar appearance为NO，然后在代码里添加:
 [application setStatusBarStyle:UIStatusBarStyleLightContent];
 */

/*
 UIViewController提供了如下属性来调整视图控制器的外观：
 1.edgesForExtendedLayout：这个属性属于UIExtendedEdge类型，它可以单独指定矩形的四条边，也可以单独指定、指定全部、全部不指定。
 使用edgesForExtendedLayout指定视图的哪条边需要扩展，不用理会操作栏的透明度。这个属性的默认值是UIRectEdgeAll。
 
 2.extendedLayoutIncludesOpaqueBars：
 如果你使用了不透明的操作栏，设置edgesForExtendedLayout的时候也请将
 extendedLayoutIncludesOpaqueBars == NO (不透明的操作栏,默认值是YES）。
 
 3.automaticallyAdjustsScrollViewInsets：如果你不想让scroll view的内容自动调整，将这个属性设为NO（默认值YES）。
 */

#import <UIKit/UIKit.h>


/**
 *  UIViewController的便捷设置
 */
@interface UIViewController (WTool)

//隐藏导航条
@property(nonatomic,assign,setter=wSetNavHiden:)BOOL wNavHiden;

#pragma mark -设置导航条返回图标图标
/**
 *  设置导航条返回按钮的图标(iOS7以上有效)
 */
-(void)wSetNavBackIndicatorImageAfterIos7:(UIImage *)aImage;
+(void)wSetAppearNavBackIndicatorImageAfterIos7:(UIImage *)aImage;

#pragma mark -加导航条左右按钮
/**
 *  设置导航条左返回按钮自动实现返回方法(wBackBtnAction)，实现方式
 *  if (self.navigationController && self.navigationController.viewControllers.count>1) {
 [self.navigationController popViewControllerAnimated:YES];
 }else {
 [self dismissViewControllerAnimated:YES completion:NULL];
 }
 */
-(void)wSetNavButtonToBack:(UIButton *)backBtn;
-(void)wSetNavButtonToBack:(UIButton *)backBtn
                  WillBack:(void(^)())willBackBlk
                  DoneBack:(void(^)())doneBackBlk;

/**
 *  加导航条左Item(保证IOS7以上与IOS6位置一样)
 */
-(void)wSetNavLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
-(void)wSetNavLeftButton:(UIButton *)leftBtn;

/**
 *  加导航条右Item(保证IOS7以上与IOS6位置一样)
 */
-(void)wSetNavRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
-(void)wSetNavRightButton:(UIButton *)rightBtn;
-(void)wSetNavRightBarBtnItems:(NSArray *)btnItems;
-(void)wSetNavRightBtns:(NSArray *)btns;

#pragma mark -导航风格
/**
 *  设置导航条半透明毛玻璃效果
 */
-(void)wSetNavBarTranslucent:(BOOL)isTranslucent;
-(BOOL)wNavBarTranslucent;
/**
 *  设置导航条标题信息(标题颜色,标题字体,标题阴影)
 */
+(void)wSetAppearNavInfoWithTextColor:(UIColor *)textColor
                                 Font:(UIFont *)textFont
                           TextShadow:(NSShadow *)shadow;
-(void)wSetNavInfoWithTextColor:(UIColor *)textColor
                           Font:(UIFont *)textFont
                     TextShadow:(NSShadow *)shadow;

/**
 *  设置导航条tint颜色
 */
-(void)wSetNavBarTintColor:(UIColor *)tintColor;
+(void)wSetAppearNavBarTintColor:(UIColor *)aColor;

/**
 *  设置导航条背景色
 */
-(void)wSetNavBarBackGroundImgColor:(UIColor *)aColor;

/**
 *  设置右滑返回(iOS7之后有效,默认YES)
 */
-(void)wSetRightSlidingToBackAfterIos7:(BOOL)isSlidingToBack;

#pragma mark - UITabBarController Or UITabBar
/**
 *  设置TabBarItem信息(正常颜色,选中颜色,正常图片,选中图片)
 */
-(void)wSetTabBarItemWithTextColorNL:(UIColor *)aTextColorNL
                         TextColorSL:(UIColor *)aTextColorSL
                               ImgNL:(UIImage *)aImgNL
                               ImgSL:(UIImage *)aImgSL;

/**
 *  Appear设置TabbarItem颜色(正常颜色,选中颜色)
 */
+(void)wSetAppearTabBarItemWithTextColorNL:(UIColor *)aTextColorNL TextColorSL:(UIColor *)aTextColorSL;

/**
 *  设置TabbarItem颜色(正常颜色,选中颜色)
 */
-(void)wSetTabBarItemWithTextColorNL:(UIColor *)aTextColorNL TextColorSL:(UIColor *)aTextColorSL;

/**
 *  设置TabbarItem图片(正常图片,选中图片)(在init方法中添加才有效)
 */
-(void)wSetTabBarItemWithImgNL:(UIImage *)aImgNL ImgSL:(UIImage *)aImgSL;

/**
 *  TabBar tint颜色
 */
-(void)wSetTabBarTintColor:(UIColor *)aColor;

#pragma mark - Other
/**
 *  让UIScrollView的内容自动调整
 *  是否开启ScrollView可以滚动整个屏幕(ios7之后有效)
 */
-(void)wSetScrollFullScreenAfterIos7:(BOOL)isFullScreen;
/**
 *  是否视图内容自动调整至全屏
 */
-(BOOL)wIsScrollFullScreenAfterIos7;

/**
 *  视图拉伸到全屏(ios7之后有效,默认YES)
 * (具体参考-(void)wSetEdgeForExtendedLayoutAfterIos7:(UIRectEdge)aRectEdge;)
 */
-(void)wSetFullScreenAfterIos7:(BOOL)isFullScreen;

/**
 *  是否视图内容自动调整至全屏(默认YES)
 */
-(BOOL)wIsFullScreenAfterIos7;

/**
 *  视图拉伸到全屏(ios7之后有效,默认UIRectEdgeAll),
 *  使用edgesForExtendedLayout指定视图的哪条边需要扩展，不用理会操作栏的透明度。
 */
-(void)wSetEdgeForExtendedLayoutAfterIos7:(UIRectEdge)aRectEdge;

/**
 *  设置是否状态栏透明(IOS7之后有效),默认YES
 */
-(void)wIsOpaqueBarsToExtendedLayoutAfterIos7:(BOOL)isOpaque;

/**
 *  相对于self.view的子视图向下偏移状态栏的高度(20)(IOS7有效)
 *
 *  @param isMove 是否偏移
 *
 *  @return 偏移的高度
 */
-(CGFloat)wIsBoundsIos6ToIos7:(BOOL)isMove;


/**
 *  当系统为IOS6时，把当前视图的子视图坐标上移20像素.
 *  坐标上移,相当于视图下移.
 *  使用IOS7的坐标方案，调用此方法,可以适配IOS6坐标方案.
 *  @return 坐标上移的像素值
 */
-(CGFloat)wIsBoundsIos7ToIos6:(BOOL)isMove;

/**
 *  子视图向下偏移状态栏的高度(20像素)
 *  @param isMove 是否偏移
 *  @return 偏移的高度
 */
-(CGFloat)wIsSubViewMoveDown20:(BOOL)isMove;

/**
 *  生成CGRect,在IOS6下，自动上移20(状态栏的高度)
 *
 *  @param x 左
 *  @param y 顶
 *  @param w 宽
 *  @param h 高
 *
 *  @return CGRect
 */
CGRect	wCGRectMake_Ios7ToIos6( CGFloat x, CGFloat y, CGFloat w, CGFloat h );

/**
 *  当系统为IOS6且自带的导航条没显示时，把当前视图的子视图坐标上移20像素.
 *  坐标上移,相当于视图下移.
 *  使用IOS7的坐标方案，调用此方法,可以适配IOS6坐标方案.
 *  @return 坐标上移的像素值
 */
-(CGFloat)wBoundsIos7ToIos6WhenNavHidenWithNavStyle:(BOOL)isNavStyleIOS7;


//Ios7下为20,Ios6下为0
-(CGFloat)wTopOfViewOffset;

/**
 *  结束编辑
 */
-(void)wEndEditing;

/**
 *  结束编辑
 */
+ (void) wEndEditingForKeyWindow;

#pragma mark - UIPopoverViewController

@property(nonatomic,assign,setter=wSetPreferredContentSize:)CGSize wPreferredContentSize;

@end

@interface UITabBarController (WTool)

/*!
 *  设置TabBar背景图
 *
 *  @param aImage TabBar背景图
 */
-(void)wSetTabBarBackgroundImg:(UIImage *)aImage;


@end








