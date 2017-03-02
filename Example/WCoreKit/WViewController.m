//
//  WViewController.m
//  WCoreKit
//
//  Created by linjiawei on 12/02/2015.
//  Copyright (c) 2015 linjiawei. All rights reserved.
//

#import "WViewController.h"

#import <WCoreKit/WImageBannerView.h>
#import <Masonry/Masonry.h>


@interface WViewController ()

@property (nonatomic, strong) WImageBannerView * bannerView;

@end

@implementation WViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.bannerView.images = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488446179791&di=50d332623141d6ad266ffecdc57e858b&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F03087bf40ad162d960aed9aa14dfa9ec8b13cdc0.jpg",@"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D360/sign=af15bbb1ccea15ce5eeee60f86003a25/9c16fdfaaf51f3de18a16c5091eef01f3a2979f7.jpg"];
    self.bannerView.autoPlayTime = 3;
    [self.bannerView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(WImageBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[WImageBannerView alloc] init];
    }
    return _bannerView;
}


@end
