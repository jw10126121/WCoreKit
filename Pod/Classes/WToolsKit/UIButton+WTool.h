//
//  UIButton+WTool.h
//  Worker
//
//  Created by Linjw on 14-2-22.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WTool)

//@property(nonatomic,retain,setter = wSetAdditionalProperty:)id wAdditionalProperty;

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
                   BGImgHL:(UIImage *)imgHL;

//把图片和文字边距归0
-(void)wSetButtonEdgeZero;

#pragma mark - SetImageAndTiele

//设置图片在文字上面
-(void)wSetImageTopWithSpace:(CGFloat)space;

//设置图片在文字左边
-(void)wSetImageLeftWithSpace:(CGFloat)space;

//设置图片在文字底部
-(void)wSetImageBottomWithSpace:(CGFloat)space;

//设置图片在文字右边
-(void)wSetImageRightWithSpace:(CGFloat)space;


/**
 *  图片在最上面
 *  @param fixSpacing 间距
 */
-(void)wSideImageTopWithFix:(CGFloat)fixSpacing;
/**
 *  图片在最左边
 *  @param fixSpacing 间距
 */
-(void)wSideImageLeftWithFix:(CGFloat)fixSpacing;
/**
 *  图片在最下面
 *  @param fixSpacing 间距
 */
-(void)wSideImageButtomWithFix:(CGFloat)fixSpacing;
/**
 *  图片在最右边
 *  @param fixSpacing 间距
 */
-(void)wSideImageRightWithFix:(CGFloat)fixSpacing;

/**
 *  标题在最上面
 *  @param fixSpacing 间距
 */
-(void)wSideTitleTopWithFix:(CGFloat)fixSpacing;
/**
 *  标题在最左边
 *  @param fixSpacing 间距
 */
-(void)wSideTitleLeftWithFix:(CGFloat)fixSpacing;
/**
 *  标题在最下面
 *  @param fixSpacing 间距
 */
-(void)wSideTitleButtomWithFix:(CGFloat)fixSpacing;
/**
 *  标题在最右边
 *  @param fixSpacing 间距
 */
-(void)wSideTitleRightWithFix:(CGFloat)fixSpacing;






@end







