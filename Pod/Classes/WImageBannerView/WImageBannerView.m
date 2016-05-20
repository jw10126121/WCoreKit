//
//  WImageBannerView.m (WImageBannerView)
//
//  Created by linjiawei on 16/5/20.
//  Copyright © 2016年 linjiawei. All rights reserved.
//

#import "WImageBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WImageBannerView ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray<UIImageView*>* imgVs;
@property(nonatomic,strong)UIScrollView * showSV;
@property(nonatomic,assign)NSInteger index;
//@property(nonatomic,strong)NSArray * images;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,assign)BOOL isLoadedData;

//@property(nonatomic,assign)BOOL isLastFrame;


@property(nonatomic,copy)WImageBannerViewClickCurrent clickCurrentHandle;
@property(nonatomic,copy)WImageBannerViewWillShowCurrent willShowCurrentHandle;
@property(nonatomic,copy)WImageBannerViewDidShowCurrent didShowCurrentHandle;
//@property(nonatomic,copy)WImageBannerViewConfigImg configImgHandle;

@end



@implementation WImageBannerView

#pragma mark - 生命周期

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _autoPlayTime = 3;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.placeholderImgFromURL = nil;
        [self awakeFromNib];
        
    }
    return self;
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    self.imgVs = [NSMutableArray<UIImageView*> new];
    
    NSInteger count = 3;
    for (NSInteger i = 0; i < count; i ++)
    {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.tag = i + 1000;
        //最中间显示的那个，是可点击的
        if (i == [self midIndexWithCount:count])
        {
            imageView.userInteractionEnabled = YES;
            imageView.image = self.placeholderImgFromURL;
        }
        [self.imgVs addObject:imageView];
        [self.showSV addSubview:imageView];
    }
    
    [self addSubview:self.showSV];
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMySelf:)];
    [self addGestureRecognizer:tapGesture];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.showSV.frame = self.bounds;
    CGSize svSize = self.showSV.frame.size;
    //    for (NSInteger i = 0; i < self.imgVs.count; i ++)
    //    {
    //        self.imgVs[i].frame = (CGRect){i * svSize.width,0,svSize};
    //        self.imgVs[i].tag = i + 1000;
    //    }
    self.isVerticalScroll = self.isVerticalScroll;
    
    [self configAllDataWithCurrentIndex:self.index];
    
    /*
     if (self.isLastFrame)
     {
     self.isLastFrame = NO;
     !self.didShowCurrentHandle ?: self.didShowCurrentHandle(self.index);
     }
     */
//    if (self.isVerticalScroll)
//    {
//        self.showSV.contentSize = (CGSize){svSize.width,svSize.height* self.imgVs.count};
//        self.showSV.contentOffset = CGPointMake(0,svSize.height * 1);//设置初始偏移量
//    }else
//    {
//        self.showSV.contentSize = (CGSize){svSize.width * self.imgVs.count,svSize.height};
//        self.showSV.contentOffset = CGPointMake(svSize.width * 1, 0);//设置初始偏移量
//    }
    
}

-(void)updateConstraints
{
    [super updateConstraints];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //    self.isLastFrame = YES;
}


-(void)reloadData
{
    /*
     for (NSInteger i = 0; i < self.imgVs.count; i ++)
     {
     //初始化数据
     if (i == 0)
     {
     [self configDataToImgV:self.imgVs[i] data:self.images.lastObject];
     }else if (i == 1)
     {
     [self configDataToImgV:self.imgVs[i] data:self.images.firstObject];
     }else if (i == 2)
     {
     id data = self.images.count > 1 ? self.images[1] : self.images.lastObject;
     [self configDataToImgV:self.imgVs[i] data:data];
     }
     }
     */
    self.index = 0;
    [self configAllDataWithCurrentIndex:self.index];
    self.autoPlayTime = self.autoPlayTime;
    
}

-(void)tapMySelf:(UITapGestureRecognizer*)tap
{
    if (self.images.count)
    {
        !self.clickCurrentHandle ?: self.clickCurrentHandle(self.index);
    }
}

-(void)stopTimer
{
    if (self.timer && self.timer.isValid)
    {
        [self.timer invalidate];
    }
    self.timer = nil;
}

-(void)startTimer
{
    if (self.autoPlayTime > 0)
    {
        if (self.timer)
        {
            [self stopTimer];
        }
        
        self.timer = [NSTimer timerWithTimeInterval:self.autoPlayTime < 1? 3 : self.autoPlayTime
                                             target:self selector:@selector(playNextImgView)
                                           userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}

-(void)playNextImgView
{
    //    if (self.images.count)
    //    {
    if (self.isVerticalScroll)
    {
        BOOL isBeiShu = (NSInteger)self.showSV.contentOffset.y%(NSInteger)self.showSV.bounds.size.height?NO:YES;
        CGFloat offsetY = ((NSInteger)self.showSV.contentOffset.y/(NSInteger)self.showSV.bounds.size.height+isBeiShu)*self.showSV.bounds.size.height;
        BOOL isAnimated = isBeiShu;
        [self.showSV setContentOffset:(CGPoint){0,self.showSV.bounds.size.height + offsetY} animated:isAnimated];
        
    }else
    {
        BOOL isBeiShu = (NSInteger)self.showSV.contentOffset.x%(NSInteger)self.showSV.bounds.size.width?NO:YES;
        CGFloat offsetX = ((NSInteger)self.showSV.contentOffset.x%(NSInteger)self.showSV.bounds.size.width+isBeiShu)*self.showSV.bounds.size.width;
        BOOL isAnimated = isBeiShu;
        [self.showSV setContentOffset:(CGPoint){self.showSV.bounds.size.width + offsetX,0} animated:isAnimated];
    }
    
    //    }
}

/*
-(void)configDataToImgV:(UIImageView *)imageView index:(NSInteger)index
{
    if (self.configImgHandle)
    {
        self.configImgHandle(imageView,index);
    }
}
*/

-(void)configDataToImgV:(UIImageView *)imageView data:(id)data
{
    
    imageView.backgroundColor = [UIColor clearColor];
    if ([data isKindOfClass:[UIColor class]])
    {
        imageView.image = nil;
        imageView.backgroundColor = data;
    }else if ([data isKindOfClass:[UIImage class]])
    {
        imageView.image = data;
    }else if ([data isKindOfClass:[NSString class]])
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:self.placeholderImgFromURL];
    } else
    {
        imageView.image = nil;
    }
}

-(NSInteger)midIndexWithCount:(NSInteger)count
{
    return 1;//count/2-1;
}


-(void)configAllDataWithCurrentIndex:(NSInteger)index
{
    for (UIImageView * imageV in self.imgVs) {
        imageV.image = nil;
    }
    if (index == 0)
    {
        [self configDataToImgV:self.imgVs[0] data:self.images.lastObject];
        [self configDataToImgV:self.imgVs[1] data:self.images.firstObject];
        if (self.images.count > 1)
        {
            [self configDataToImgV:self.imgVs[2] data:self.images[1 + index]];
        }else
        {
            [self configDataToImgV:self.imgVs[2] data:self.images.lastObject];
        }
    } else if (index == self.images.count - 1)
    {
        if (self.images.count == 1)
        {
            [self configDataToImgV:self.imgVs[0] data:self.images.firstObject];
        }else
        {
            [self configDataToImgV:self.imgVs[0] data:self.images[index-1]];
        }
        [self configDataToImgV:self.imgVs[1] data:self.images[index]];
        [self configDataToImgV:self.imgVs[2] data:self.images.firstObject];
    }else
    {
        [self configDataToImgV:self.imgVs[0] data:self.images[index - 1]];
        [self configDataToImgV:self.imgVs[1] data:self.images[index]];
        if (self.images.count > 1)
        {
            [self configDataToImgV:self.imgVs[2] data:self.images[index+1]];
        }else
        {
            [self configDataToImgV:self.imgVs[2] data:self.images[index]];
        }
    }
    
}

#pragma mark - UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == self.showSV)
    {
        CGSize svSize = scrollView.frame.size;
        if (self.isVerticalScroll)
        {
            // 右滑,下一个
            if (scrollView.contentOffset.y >= svSize.height * ([self midIndexWithCount:self.images.count]+1))
            {
                //如果是最后一个，就设置为下一个序号=0,否则下一个序号+1
                if (self.index == self.images.count - 1)
                {
                    self.index = 0;
                }else
                {
                    self.index ++;
                }
                !self.willShowCurrentHandle ?: self.willShowCurrentHandle(self.index);
                self.showSV.contentOffset = (CGPoint){0,svSize.height};
                [self configAllDataWithCurrentIndex:self.index];
                !self.didShowCurrentHandle ?: self.didShowCurrentHandle(self.index);
                
            }  //左滑，上一个
            else if(scrollView.contentOffset.y <= ([self midIndexWithCount:self.images.count]-1))
            {
                if (self.index == 0)
                {
                    self.index = self.images.count -1;
                }else
                {
                    self.index --;
                }
                !self.willShowCurrentHandle ?: self.willShowCurrentHandle(self.index);
                self.showSV.contentOffset = (CGPoint){0,svSize.height};
                [self configAllDataWithCurrentIndex:self.index];
                !self.didShowCurrentHandle ?: self.didShowCurrentHandle(self.index);
            }
        }else
        {
            // 右滑,下一个
            if (scrollView.contentOffset.x >= svSize.width * ([self midIndexWithCount:self.images.count]+1))
            {
                //如果是最后一个，就设置为下一个序号=0,否则下一个序号+1
                if (self.index == self.images.count - 1)
                {
                    self.index = 0;
                }else
                {
                    self.index ++;
                }
                !self.willShowCurrentHandle ?: self.willShowCurrentHandle(self.index);
                self.showSV.contentOffset = (CGPoint){svSize.width,0};
                [self configAllDataWithCurrentIndex:self.index];
                !self.didShowCurrentHandle ?: self.didShowCurrentHandle(self.index);
                
            }  //左滑，上一个
            else if(scrollView.contentOffset.x <= ([self midIndexWithCount:self.images.count]-1))
            {
                if (self.index == 0)
                {
                    self.index = self.images.count -1;
                }else
                {
                    self.index --;
                }
                !self.willShowCurrentHandle ?: self.willShowCurrentHandle(self.index);
                self.showSV.contentOffset = (CGPoint){svSize.width,0};
                [self configAllDataWithCurrentIndex:self.index];
                !self.didShowCurrentHandle ?: self.didShowCurrentHandle(self.index);
            }
        }
        
    }
}

//防止计时器与拖动手势冲突
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}


#pragma mark - 属性相关

-(UIScrollView *)showSV
{
    if (_showSV == nil)
    {
        _showSV = [[UIScrollView alloc]init];
        _showSV.showsHorizontalScrollIndicator = NO;//隐藏滚动条
        _showSV.pagingEnabled = YES;//设置分页
        _showSV.delegate = self;
    }
    return _showSV;
}


-(void)setAutoPlayTime:(CGFloat)autoPlayTime
{
    _autoPlayTime = autoPlayTime;
    if (_autoPlayTime > 0)
    {
        [self startTimer];
    }else
    {
        [self stopTimer];
    }
}


-(void)setImages:(NSArray *)images
{
    if (_images != images)
    {
        _images = images;
        
        [self reloadData];
    }
    
}


-(void)setIsVerticalScroll:(BOOL)isVerticalScroll
{
    _isVerticalScroll = isVerticalScroll;
    CGSize svSize = self.showSV.frame.size;
    for (NSInteger i = 0; i < self.imgVs.count; i ++)
    {
        if (_isVerticalScroll)
        {
            self.imgVs[i].frame = (CGRect){0,i * svSize.height,svSize};
        }else
        {
            self.imgVs[i].frame = (CGRect){i * svSize.width,0,svSize};
        }
        self.imgVs[i].tag = i + 1000;
    }

    if (self.isVerticalScroll)
    {
        self.showSV.contentSize = (CGSize){svSize.width,svSize.height* self.imgVs.count};
        self.showSV.contentOffset = CGPointMake(0,svSize.height * 1);//设置初始偏移量
    }else
    {
        self.showSV.contentSize = (CGSize){svSize.width * self.imgVs.count,svSize.height};
        self.showSV.contentOffset = CGPointMake(svSize.width * 1, 0);//设置初始偏移量
    }
}

@end











