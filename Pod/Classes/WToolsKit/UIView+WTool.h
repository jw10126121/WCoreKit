//
//  UIView+WTool.h
//
//  Created by Linjw on 2013/11/30.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视图
 */
@interface UIView (WTool)

@property(nonatomic,retain,setter = wSetAdditionalProperty:)id wAdditionalProperty;

//为UIView添加属性
@property (nonatomic,  assign) CGFloat x;                //x坐标
@property (nonatomic,  assign) CGFloat left;             //x坐标
@property (nonatomic,  assign) CGFloat top;              //y坐标
@property (nonatomic,  assign) CGFloat y;                //y坐标
@property (nonatomic,  assign) CGFloat right;            //右边坐标
@property (nonatomic,  assign) CGFloat bottom;           //底坐标
@property (nonatomic,  assign) CGFloat width;            //宽
@property (nonatomic,  assign) CGFloat height;           //高
@property (nonatomic,  assign) CGSize  size;             //大小
@property (nonatomic,  assign) CGPoint origin;           //起点
@property (nonatomic,  assign) CGFloat centerX;          //中点x坐标
@property (nonatomic,  assign) CGFloat centerY;          //中心点Y坐标
@property (nonatomic,readonly) CGFloat screenX;          //在屏幕上的x坐标
@property (nonatomic,readonly) CGFloat screenY;          //在屏幕上的y坐标
@property (nonatomic,readonly) CGFloat screenViewX;      //屏幕上的x坐标,考虑滚动视图。
@property (nonatomic,readonly) CGFloat screenViewY;      //屏幕上的y坐标,考虑滚动视图。
@property (nonatomic,readonly) CGRect  screenFrame;      //在屏幕上返回视图frame,考虑滚动视图。
@property (nonatomic,readonly) CGFloat orientationWidth; //Return the width in portrait or the height in landscape.
@property (nonatomic,readonly) CGFloat orientationHeight;//Return the height in portrait or the width in landscape.
@property (nonatomic,  assign) CGSize  boundsSize;
@property (nonatomic,  assign) CGFloat boundsWidth;
@property (nonatomic,  assign) CGFloat boundsHeight;
@property (nonatomic,readonly) CGRect  contentBounds;
@property (nonatomic,readonly) CGPoint contentCenter;

-(id)initWithOrigin:(CGPoint)origin Size:(CGSize)size;
-(id)initWithCenter:(CGPoint)center Size:(CGSize)size;

-(void)wConfigViewWithFrame:(CGRect)frame
                    BgColor:(UIColor *)bgColor
                      BgImg:(UIImage *)bgImg;

//Finds the first descendant view (including this view) that is a member of a particular class.
- (UIView*)descendantOrSelfWithClass:(Class)cls;
//Finds the first ancestor view (including this view) that is a member of a particular class.
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * 移除所有子视图
 */
- (void)wRemoveAllSubviews;

- (CGPoint)wOffsetFromView:(UIView*)otherView;

/**
 *  添加点击事件
 */
- (void)wSetTapActionWithBlock:(void (^)(void))block;

/**
 *  添加长按事件
 */
- (void)wSetLongPressActionWithBlock:(void (^)(void))block;


//设置左右(改变宽)
- (void)wSetLeft:(CGFloat)left right:(CGFloat)right;
//设置宽和右(重置左)
- (void)wSetWidth:(CGFloat)width right:(CGFloat)right;
//设置顶底(改变高)
- (void)wSetTop:(CGFloat)top bottom:(CGFloat)bottom;
//设置高和底(重围顶)
- (void)wSetHeight:(CGFloat)height bottom:(CGFloat)bottom;


CGRect	wCGRectMakeWithCenter( CGPoint center, CGSize size );
CGRect	wCGRectMakeWithOrigin( CGPoint origin, CGSize size );
CGFloat	wCGRectMaxX( CGRect rect );
CGFloat	wCGRectMaxY( CGRect rect );
CGRect	wCGRectMakeCenteredRect( CGRect superviewRect, CGSize subviewSize );
CGRect  wCGRectMakeWithEdgeInsets( CGRect rect, UIEdgeInsets insets );
CGRect	wCGRectMakeIntegral( CGRect rect );
BOOL	wCGRectIsInvalid( CGRect rect );


-(UIViewController *)wFirstResponderViewController;

//查找viewSuper下焦点所在的VIEW
+(UIView *)wViewForFirstResponderWithSuperView:(UIView *)viewSuper;

//查找当前焦点所在的view在keyWindow上面的位置
+(CGRect)wRectForFirstResponderViewInKeyWindow;

//查找当前焦点所在的view在viewSuper上面的位置
+(CGRect)wRectForFirstResponderViewWithSuperView:(UIView *)viewSuper;

//得到当前视图在 superView 上的位置
- (CGRect)wRectInSuperView:(UIView *)viewSuper;

//所有子视图的坐标向下偏移20像素
-(CGFloat)wIsSubViewMoveDown20:(BOOL)isMove;

//截图
+ (UIImage *) wImageScreenShotWithView:(UIView *)aView;
- (UIImage *) wImageScreenShot;

//加线
- (UIView *)wAddBottomLineWithWidth:(CGFloat)width color:(UIColor *)color;
- (UIView *)wAddVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x;

-(UIView *)wAddLineTopOrBottom:(NSInteger)direction Height:(CGFloat)height Color:(UIColor *)aColor;

@end


@interface UIView(LayerEffects)

//背景图
@property(nonatomic,retain,setter=wSetBackgroundImage:)UIImage * wBackgroundImage;

//设置圆角
- (void) wSetCornerRadius:(CGFloat)radius;

//设置粗边
- (void) wSetBorder:(UIColor *)color Width:(CGFloat) width;

//设置阴影
// Example: [view setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blueRadius:3.0];
- (void) wSetShadow:(UIColor *)color
            Opacity:(CGFloat)opacity
             Offset:(CGSize)offset
         BlurRadius:(CGFloat)blurRadius;


@end



@interface UIView(Animation)

/**
 *  设置视图随着键盘通知作相应操作
 *
 *  @param aNotification 键盘通知
 *  @param animation     相应处理
 *  @param completionSel 动画完成操作
 */
+ (void)wAnimationWithKeyboardNotification:(NSNotification *)aKeyboardNotification
                                 Animation:(void(^)(void))animation
                             CompletionSel:(SEL)completionSel;

+ (void)wAnimationWithKeyboardNotification:(NSNotification *)aKeyboardNotification
                                 Animation:(void(^)(void))animation
                                Completion:(void (^)(void))completion;

//animation

- (void)wCrossfadeWithDuration:(NSTimeInterval)duration;

- (void)wCrossfadeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end



























