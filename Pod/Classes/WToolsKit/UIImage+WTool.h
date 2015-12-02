//
//  UIImage+WTool.h
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (WTool)

@property (nonatomic,assign,readonly)CGFloat   height;
@property (nonatomic,assign,readonly)CGFloat   width;

/**
 *  截图
 *
 *  @param aView 视图
 *
 *  @return 根据视图生成的图
 */
+ (UIImage *) wImageScreenShotWithView:(UIView *)aView;
UIImage * wImageScreenshot(UIView * aView);

/**
 *  从图片中取部分图片
 *
 *  @param aImage       被操作的图片
 *  @param aSubRect     子图片大小
 *  @param isFromCenter 是否从中心点取
 *
 *  @return 子图
 */
+ (UIImage *) wSubImage:(UIImage *)aImage SubRect:(CGRect)aSubRect IsCenter:(BOOL)isFromCenter;
- (UIImage *) wImageWithSubRect:(CGRect)aSubRect IsCenter:(BOOL)isFromCenter;

/**
 *  缩放图片
 *
 *  @param aImage 图片源
 *  @param toSize 缩放后的大小
 *
 *  @return 缩放后的图片
 */
+ (UIImage *) wImageScaleWithImage:(UIImage *)aImage ToSize:(CGSize)toSize;
- (UIImage *) wImageScaleToSize:(CGSize)toSize;

/**
 *  依据相对正北的方向转变图片的方向
 *
 *  @param aImage    一张图片
 *  @param toDegrees 角度
 *
 *  @return 转向后的图片
 */
+ (UIImage *) wImageRotatedWithImage:(UIImage *)aImage ToDegrees:(CGFloat)toDegrees;
- (UIImage *) wImageRotatedToDegrees:(CGFloat)toDegrees;


/**
 *  设置图片圆角
 *
 *  @param image  图片
 *  @param size   大小
 *  @param radius 圆角
 *
 *  @return 设置圆角后的图片
 */
+ (UIImage *) wImageRoundedWithImage:(UIImage*)aImage Radius:(NSInteger)radius Size:(CGSize)size;
- (UIImage *) wImageRoundedToRadius:(NSInteger)radius Size:(CGSize)size;

/**
 *  图片模糊
 *
 *  @param blurAmount 度
 *
 *  @return 模糊后的图片
 */
- (UIImage*)wImageBlurredWithAmount:(CGFloat)blurAmount;

- (UIImage *)wImageBlurWithRadius:(CGFloat)blurRadius
                        TintColor:(UIColor *)tintColor
            SaturationDeltaFactor:(CGFloat)saturationDeltaFactor
                        MaskImage:(UIImage *)maskImage;

/**
 *  颜色生成图片
 *
 *  @param aColor 颜色
 *
 *  @return 图片
 */
+ (UIImage *)wImageWithColor:(UIColor *)aColor;

/*!
 *  颜色生成图片
 *
 *  @param aColor       颜色
 *  @param cornerRadius 圆角半径
 *
 *  @return 图片
 */
+ (UIImage *)wImageWithColor:(UIColor *)aColor CornerRadius:(CGFloat)cornerRadius;

/**
 *  改变图片透明度
 *
 *  @param alpha 不透明比
 */
- (UIImage *)wImageWithApplyingAlpha:(CGFloat)alpha;

/**
 *  颜色生成图片
 *
 *  @param aColor       颜色
 *  @param cornerRadius 圆角半径
 *  @param aSize        图片大小
 *
 *  @return 图片
 */
+ (UIImage *)wImageWithColor:(UIColor *)aColor CornerRadius:(CGFloat)cornerRadius Size:(CGSize)aSize;

/*!
 *  固定方向
 *
 *  @return 图片
 */
- (UIImage *)wImageForFixOrientation;

/**
 *  颜色填充图片
 */
- (UIImage *)wImageMarkWithColor:(UIColor *)aColor;

/**
 *  水平反转
 */
- (UIImage *)wImageHorizontallyFlipped;

/**
 *  9宫格图处理
 *
 *  @return 拉伸后的图片
 */
-(UIImage *)wImageWithLeftCapWidth;

#pragma mark - GIF相关
/*!
 *  得到GIF动图时间
 *
 *  @param dataForGIF GIF图Data
 *
 *  @return 运行时间
 */
+ (NSTimeInterval)wDurationForGIFData:(NSData *)dataForGIF;

/*!
 *  得到GIF动图所有图片
 *
 *  @param dataForGIF GIF图Data
 *
 *  @return GIF动图所有图片
 */
+ (NSArray *)wImagesWithGIFData:(NSData *)dataForGIF;

/*!
 *  根据GIF动图生成UIImageView
 *
 *  @param dataForGIF GIF图Data
 *
 *  @return UIImageView
 */
+ (UIImageView *)wImgViewWithGIFData:(NSData *)dataForGIF;

/**
 *  黑色改变颜色成其他颜色
 */
-(UIImage *)wImageBlackToTransparentWithColor:(UIColor *)aColor;

#pragma mark - 二维码，条形码

/**
 *  生成二维码CIImage
 */
+(CIImage *)wCIImageWithQrCode:(NSString *)qrCode;

/**
 *  通过CIImage生成二维码
 */
+(UIImage *)wImageWithQrCIImage:(CIImage *)qrCIImage Size:(CGSize)qrCodeSize;

/**
 *  生成二维码
 */
+(UIImage *)wImageWithQrCode:(NSString *)qrCode Size:(CGSize)qrCodeSize;

/**
 *  生成条形码(CICode128BarcodeGenerator)
 */
+(UIImage *)wImageWithBarCode:(NSString *)barCode Size:(CGSize)barCodeSize;






@end

















