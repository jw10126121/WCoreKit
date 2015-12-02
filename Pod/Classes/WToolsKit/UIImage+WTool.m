//
//  UIImage+WTool.m
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "UIImage+WTool.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
@implementation UIImage (WTool)

-(CGFloat)height{
    return self.size.height;
}

-(CGFloat)width{
    return self.size.width;
}


/**
 *  截图
 *
 *  @param aView 视图
 *
 *  @return 根据视图生成的图
 */
+ (UIImage *) wImageScreenShotWithView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0.0);
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
    BOOL ios7_Or_Later = [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0;
    if (ios7_Or_Later)
    {
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:YES];
    }else
    {
        [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
#else
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
#endif
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  截图
 */
UIImage * wImageScreenshot(UIView * aView)
{
    return [UIImage wImageScreenShotWithView:aView];

}

+ (UIImage *)wSubImage:(UIImage *)aImage SubRect:(CGRect)aSubRect IsCenter:(BOOL)isFromCenter
{
    /*如若isFromCenter为Yes则是由中心点取mCGRect范围的图片*/
    float imgwidth = aImage.size.width;
    float imgheight = aImage.size.height;
    float viewwidth = aSubRect.size.width;
    float viewheight = aSubRect.size.height;
    CGRect rect;
    if(isFromCenter)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    CGImageRef subImageRef = CGImageCreateWithImageInRect(aImage.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

- (UIImage *) wImageWithSubRect:(CGRect)aSubRect IsCenter:(BOOL)isFromCenter
{
    return [[self class] wSubImage:self SubRect:aSubRect IsCenter:isFromCenter];
}

/**
 *  缩放图片
 *
 *  @param toSize 缩放后的大小
 *
 *  @return 缩放后的图片
 */
- (UIImage *) wImageScaleToSize:(CGSize)toSize
{
    return [[self class] wImageScaleWithImage:self ToSize:toSize];
}

+ (UIImage *) wImageScaleWithImage:(UIImage *)aImage ToSize:(CGSize)toSize
{
    UIGraphicsBeginImageContext(toSize);  //size 为CGSize类型，即你所需要的图片尺寸
    [aImage drawInRect:CGRectMake(0, 0, toSize.width, toSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

- (UIImage *) wImageRotatedToDegrees:(CGFloat)toDegrees
{
    return [[self class] wImageRotatedWithImage:self ToDegrees:toDegrees];
}

/**
 *  依据相对正北的方向转变图片的方向
 *
 *  @param aImage    一张图片
 *  @param toDegrees 角度
 *
 *  @return 转向后的图片
 */
+ (UIImage *) wImageRotatedWithImage:(UIImage *)aImage ToDegrees:(CGFloat)toDegrees
{
    if (!aImage)  return nil;
    
    CGSize rotatedSize = aImage.size;
    
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO))
    {
        rotatedSize.width *= 2;
        rotatedSize.height *= 2;
    }
    UIGraphicsBeginImageContext(rotatedSize);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, toDegrees * M_PI / 180);
    
    CGContextRotateCTM(bitmap, M_PI);
    
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), aImage.CGImage);
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/**
 *  设置图片圆角
 *
 *  @param image  图片
 *  @param size   大小
 *  @param radius 圆角
 *
 *  @return 设置圆角后的图片
 */
+ (UIImage *) wImageRoundedWithImage:(UIImage*)aImage Radius:(NSInteger)radius Size:(CGSize)size
{
    if (!aImage)  return nil;
    int w = size.width;
    int h = size.height;
    UIImage * img = aImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}

- (UIImage *) wImageRoundedToRadius:(NSInteger)radius Size:(CGSize)size
{
    return [[self class] wImageRoundedWithImage:self Radius:radius Size:size];
}

- (UIImage*)wImageBlurredWithAmount:(CGFloat)blurAmount
{
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (!error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)wImageBlurWithRadius:(CGFloat)blurRadius
                        TintColor:(UIColor *)tintColor
            SaturationDeltaFactor:(CGFloat)saturationDeltaFactor
                        MaskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage *)wImageWithColor:(UIColor *)color
{
    return [self wImageWithColor:color CornerRadius:0];
}

- (UIImage *)wImageWithApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)wImageWithColor:(UIColor *)aColor CornerRadius:(CGFloat)cornerRadius Size:(CGSize)aSize
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

//颜色生成图片
+ (UIImage *)wImageWithColor:(UIColor *)aColor
                CornerRadius:(CGFloat)cornerRadius
{
    return [self wImageWithColor:aColor CornerRadius:cornerRadius Size:CGSizeMake(1, 1)];
}

- (UIImage *)wImageForFixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  颜色填充图片
 */
- (UIImage *)wImageMarkWithColor:(UIColor *)aColor {
    if (aColor == nil) {
        return self;
    }
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  水平填充
 */
- (UIImage *)wImageHorizontallyFlipped {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

/**
 *  9宫格图处理
 *
 *  @return 拉伸后的图片
 */
-(UIImage *)wImageWithLeftCapWidth
{
    return [self stretchableImageWithLeftCapWidth:floorf(self.size.width/2)
                                     topCapHeight:floorf(self.size.height/2)];
}

+ (NSTimeInterval)wDurationForGIFData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration = 0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES) {
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes length:3] options:NSDataSearchBackwards range:dataSearchLeftRange];
        if (frameDescriptorRange.location != NSNotFound) {
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location + 4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        } else {
            break;
        }
    }
    return duration / 100;
}

+ (UIImageView *)wImgViewWithGIFData:(NSData *)dataForGIF{
    NSTimeInterval duration = [self wDurationForGIFData:dataForGIF];
#if ! __has_feature(objc_arc)
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)dataForGIF, NULL);
#else
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)dataForGIF, NULL);
#endif
    UIImageView *imageView = [[self class] imageViewWithAnimatedGIFImageSource:source andDuration:duration];
    CFRelease(source);
    return imageView;
}

+ (UIImageView *)imageViewWithAnimatedGIFImageSource:(CGImageSourceRef)source
                                         andDuration:(NSTimeInterval)duration
{
    if (!source) {
        return nil;
    }
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage) {
            return nil;
        }
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([images count] > 0) {
        imageView.image = [images objectAtIndex:0];
    }
    [imageView setAnimationImages:images];
    [imageView setHighlighted:NO];
    [imageView setAnimationDuration:duration];
    [imageView sizeToFit];
    NSArray *arr = [NSArray arrayWithObject:NSRunLoopCommonModes];
    [imageView performSelector:@selector(startAnimating) withObject:nil afterDelay:0.1f inModes:arr];
#if ! __has_feature(objc_arc)
    return [imageView autorelease];
#else
    return imageView;
#endif
}

+ (NSArray *)wImagesWithGIFData:(NSData *)data {
#if ! __has_feature(objc_arc)
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
#else
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
#endif
    if (!source) {
        return nil;
    }
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage) {
            return nil;
        }
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    return images;
}

/**
 *  黑色改变颜色成其他颜色
 */
-(UIImage *)wImageBlackToTransparentWithColor:(UIColor *)aColor
{
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1.0;
    if (aColor)
    {
        [aColor getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, __ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

void __ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

#pragma mark - 二维码，条形码

/**
 *  生成二维码CIImage
 */
+(CIImage *)wCIImageWithQrCode:(NSString *)qrCode
{
    NSData *stringData = [qrCode dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

/**
 *  通过CIImage生成二维码
 */
+(UIImage *)wImageWithQrCIImage:(CIImage *)qrCIImage Size:(CGSize)qrCodeSize
{
    CGRect extent = CGRectIntegral(qrCIImage.extent);
    CGFloat scale = MIN(qrCodeSize.width/CGRectGetWidth(extent), qrCodeSize.height/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrCIImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成二维码
 */
+(UIImage *)wImageWithQrCode:(NSString *)qrCode Size:(CGSize)qrCodeSize
{
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [qrCode dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置filter的默认值, 因为之前如果使用过滤镜，输入有可能会被保留，因此，在使用滤镜之前，最好设置恢复默认值
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = qrCodeSize.width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = qrCodeSize.height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];

}

/**
 *  生成条形码
 */
+(UIImage *)wImageWithBarCode:(NSString *)barCode Size:(CGSize)barCodeSize
{
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [barCode dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = barCodeSize.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = barCodeSize.height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

#pragma mark - Other
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


@end
