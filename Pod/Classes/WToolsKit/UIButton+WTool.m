//
//  UIButton+WTool.m
//
//
//  Created by Linjw on 14-2-22.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIButton+WTool.h"
//#import <objc/runtime.h>

@implementation UIButton (WTool)
/*
char * const kPropertyIdentificationKey_wAdditionalProperty = "kPropertyIdentificationKey_wAdditionalProperty";
-(void)wSetAdditionalProperty:(id)wAdditionalProperty
{
    objc_setAssociatedObject(self,kPropertyIdentificationKey_wAdditionalProperty,wAdditionalProperty,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)wAdditionalProperty
{
    return objc_getAssociatedObject(self,kPropertyIdentificationKey_wAdditionalProperty);
}
 */

/**
 *  设置按钮正常状态下的属性
 *
 *  @param frame        大小位置
 *  @param titleNL      文字
 *  @param titleColorNL 文字颜色
 *  @param bgColor      背景颜色
 *  @param imgNL        正常背景图片
 *  @param imgHL        选中背景图片
 */
-(void)wConfigBtnWithFrame:(CGRect)frame
                   TitleNL:(NSString *)titleNL
              TitleColorNL:(UIColor *)titleColorNL
                   BGColor:(UIColor *)bgColor
                   BGImgNL:(UIImage *)imgNL
                   BGImgHL:(UIImage *)imgHL
{
    self.frame = frame;
    if (titleNL) {
        [self setTitle:titleNL forState:UIControlStateNormal];
    }
    if (titleColorNL) {
        [self setTitleColor:titleColorNL forState:UIControlStateNormal];
    }
    if (bgColor) {
        [self setBackgroundColor:bgColor];
    }
    if (imgNL) {
        [self setBackgroundImage:imgNL forState:UIControlStateNormal];
    }
    if (imgHL) {
        [self setBackgroundImage:imgHL forState:UIControlStateHighlighted];
    }
}

//把图片和文字边距归0
-(void)wSetButtonEdgeZero
{
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;
}

#pragma mark - SetImageAndTiele
//设置图片在文字上面
-(void)wSetImageTopWithSpace:(CGFloat)space
{
    [self resetImageAndTitleWithFix:space/2 withType:0];
}

//设置图片在文字左边
-(void)wSetImageLeftWithSpace:(CGFloat)space
{
    [self resetImageAndTitleWithFix:space/2 withType:1];
}

//设置图片在文字底部
-(void)wSetImageBottomWithSpace:(CGFloat)space
{
    [self resetImageAndTitleWithFix:space/2 withType:2];
}

//设置图片在文字右边
-(void)wSetImageRightWithSpace:(CGFloat)space
{
    [self resetImageAndTitleWithFix:space/2 withType:3];
}


-(void)resetImageAndTitleWithFix:(CGFloat)fixSpacing withType:(NSInteger)type
{
    //取得中心点(按钮默认图片在左文字在右)
    CGPoint startImageViewCenter = self.imageView.center;
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    CGRect imageBounds =self.imageView.bounds;
    CGRect titleBounds = self.titleLabel.bounds;
    
    CGFloat imageEdgeInsetsTop=0, imageEdgeInsetsLeft=0, imageEdgeInsetsBottom=0, imageEdgeInsetsRight=0;
    CGFloat titleEdgeInsetsTop=0, titleEdgeInsetsLeft=0, titleEdgeInsetsBottom=0, titleEdgeInsetsRight=0;
    
    switch (type)
    {
        case 0:
        {
            //Top
            // 设置imageEdgeInsets    向上移的高度为文本高度的一半,向左移动到整个按钮的中心点
            imageEdgeInsetsTop = -CGRectGetMidY(titleBounds)-fixSpacing;
            imageEdgeInsetsLeft = CGRectGetMidX(self.bounds) - startImageViewCenter.x;
            imageEdgeInsetsBottom = -imageEdgeInsetsTop;
            imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            
            // 设置titleEdgeInsets    向下移的高度为图片高度的一半,向左移动到整个按钮的中心点
            titleEdgeInsetsTop = CGRectGetMidY(imageBounds)+fixSpacing;
            titleEdgeInsetsLeft = CGRectGetMidX(self.bounds) - startTitleLabelCenter.x;
            titleEdgeInsetsBottom = -titleEdgeInsetsTop;
            titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        }
            break;
        case 1:{
            //Left
            // 设置imageEdgeInsets    上下左右不变在按钮中心点,只移动间距
            imageEdgeInsetsTop = 0;
            imageEdgeInsetsLeft = -fixSpacing;
            imageEdgeInsetsBottom = 0;
            imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            
            // 设置titleEdgeInsets    上下左右不变在按钮中心点,只移动间距
            titleEdgeInsetsTop = 0;
            titleEdgeInsetsLeft = fixSpacing;
            titleEdgeInsetsBottom = 0;
            titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        }
            break;
        case 2:{
            //Buttom
            // 设置imageEdgeInsets    向下移的高度为文本高度的一半,向左移动到整个按钮的中心点
            imageEdgeInsetsTop = CGRectGetMidY(titleBounds)+fixSpacing;
            imageEdgeInsetsLeft = CGRectGetMidX(self.bounds) - startImageViewCenter.x;
            imageEdgeInsetsBottom = -imageEdgeInsetsTop;
            imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            
            // 设置titleEdgeInsets    向上移的高度为文本高度的一半,向左移动到整个按钮的中心点
            titleEdgeInsetsTop = -CGRectGetMidY(imageBounds)-fixSpacing;
            titleEdgeInsetsLeft = CGRectGetMidX(self.bounds) - startTitleLabelCenter.x;
            titleEdgeInsetsBottom = -titleEdgeInsetsTop;
            titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        }
            break;
        case 3:{
            //Right
            // 设置imageEdgeInsets    上下不变在按钮中心点,移动文本的宽度
            imageEdgeInsetsTop = 0;
            imageEdgeInsetsLeft = titleBounds.size.width+fixSpacing;
            imageEdgeInsetsBottom = -imageEdgeInsetsTop;
            imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            
            // 设置titleEdgeInsets    上下不变在按钮中心点,移动图片的宽度
            titleEdgeInsetsTop = 0;
            titleEdgeInsetsLeft = -imageBounds.size.width-fixSpacing;
            titleEdgeInsetsBottom = -titleEdgeInsetsTop;
            titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        }
            break;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop,imageEdgeInsetsLeft, imageEdgeInsetsBottom,imageEdgeInsetsRight);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop,titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}

-(void)wSideImageTopWithFix:(CGFloat)fixSpacing
{
    //取得中心点(按钮默认图片在左文字在右)
    CGPoint startImageViewCenter = self.imageView.center;
    CGRect imageBounds = self.imageView.bounds;
    CGFloat imageEdgeInsets = startImageViewCenter.y - CGRectGetMinY(imageBounds) - fixSpacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, imageEdgeInsets, 0);
}



////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideImageLeftWithFix:(CGFloat)fixSpacing
{
    CGPoint startImageViewCenter = self.imageView.center;
    CGRect imageBounds = self.imageView.bounds;
    CGFloat imageEdgeInsets = startImageViewCenter.x - CGRectGetMidX(imageBounds) -fixSpacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -imageEdgeInsets, 0,imageEdgeInsets);
}


////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideImageButtomWithFix:(CGFloat)fixSpacing
{
    //取得中心点(按钮默认图片在左文字在右)
    CGPoint startImageViewCenter = self.imageView.center;
    CGRect imageBounds = self.imageView.bounds;
    CGFloat imageEdgeInsets = startImageViewCenter.y - CGRectGetMinY(imageBounds) -fixSpacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets, 0, 0, 0);
}


////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideImageRightWithFix:(CGFloat)fixSpacing
{
    CGPoint startImageViewCenter = self.imageView.center;
    CGRect imageBounds = self.imageView.bounds;
    CGFloat imageEdgeInsets = self.bounds.size.width - startImageViewCenter.x -CGRectGetMidX(imageBounds)-fixSpacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsets, 0, -imageEdgeInsets);
}


////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideTitleTopWithFix:(CGFloat)fixSpacing
{
    //取得中心点(按钮默认图片在左文字在右)
    CGPoint startTitleCenter = self.titleLabel.center;
    CGRect titleBounds = self.titleLabel.bounds;
    CGFloat titleEdgeInsets = startTitleCenter.y - CGRectGetMinY(titleBounds) - fixSpacing;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, titleEdgeInsets, 0);
}



////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideTitleLeftWithFix:(CGFloat)fixSpacing
{
    CGPoint startTitleCenter = self.titleLabel.center;
    CGRect titleBounds = self.titleLabel.bounds;
    CGFloat titleEdgeInsets = startTitleCenter.x - CGRectGetMidX(titleBounds) -fixSpacing;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -titleEdgeInsets, 0,titleEdgeInsets);
}


////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideTitleButtomWithFix:(CGFloat)fixSpacing
{
    //取得中心点(按钮默认图片在左文字在右)
    CGPoint startTitleCenter = self.titleLabel.center;
    CGRect titleBounds = self.titleLabel.bounds;
    CGFloat titleEdgeInsets = startTitleCenter.y - CGRectGetMinY(titleBounds) -fixSpacing;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets, 0, 0, 0);
}


////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
-(void)wSideTitleRightWithFix:(CGFloat)fixSpacing
{
    CGPoint startTitleCenter = self.titleLabel.center;
    CGRect titleBounds = self.titleLabel.bounds;
    CGFloat titleEdgeInsets = self.bounds.size.width - startTitleCenter.x -CGRectGetMidX(titleBounds)-fixSpacing;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleEdgeInsets, 0, -titleEdgeInsets);
}


@end
