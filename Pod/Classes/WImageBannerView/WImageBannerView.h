//
//  WImageBannerView.h (WImageBannerView)
//
//  Created by linjiawei on 16/5/20.
//  Copyright © 2016年 linjiawei. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE


typedef void(^WImageBannerViewClickCurrent)(NSInteger index);
typedef BOOL(^WImageBannerViewWillShowCurrent)(NSInteger index);
typedef void(^WImageBannerViewDidShowCurrent)(NSInteger index);

/**
 *  广告轮播图
 */
@interface WImageBannerView : UIView

//图片信息,可以是UIImage或NSString或NSURL
@property(nonatomic,strong)NSArray * images;

//当前滚动索引
@property(nonatomic,assign)NSInteger currentIndex;

//自动滚动的时间,当<=0时，不自动滚动,默认 3s
@property(nonatomic,assign)IBInspectable CGFloat autoPlayTime;

//是否垂直滚动,当==YES时，垂直滚动,默认 NO
@property(nonatomic,assign)IBInspectable BOOL isVerticalScroll;

//网络请求时的占位图
@property(nonatomic,strong)IBInspectable UIImage * placeholderImgFromURL;

//是否循环引用
@property(nonatomic,assign)BOOL isCycleScroll;

//重新加载数据
-(void)reloadData;




//点击
-(void)setClickCurrentHandle:(WImageBannerViewClickCurrent)clickCurrentHandle;
//将要显示
-(void)setWillShowCurrentHandle:(WImageBannerViewWillShowCurrent)willShowCurrentHandle;
//显示完
-(void)setDidShowCurrentHandle:(WImageBannerViewDidShowCurrent)didShowCurrentHandle;






@end







