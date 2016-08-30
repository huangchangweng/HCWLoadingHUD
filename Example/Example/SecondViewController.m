//
//  SecondViewController.m
//  Example
//
//  Created by HCW on 16/8/30.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import "SecondViewController.h"
#import "HCWLoadingHUD.h"

@interface SecondViewController () <HCWLoadingHUDDelegate>
@property (nonatomic, strong) HCWLoadingHUD *loadingHUD;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingHUD = [HCWLoadingHUD new];
    self.loadingHUD.delegate = self;
    [self.loadingHUD setText:@"服务器错误点击屏幕重新加载" forState:HCWLoadingHUDLoadOther];
    [self.loadingHUD setText:@"未知错误点击屏幕返回" forState:HCWLoadingHUDLoadError];

    // 开始加载
    [self.loadingHUD showInViewController:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 服务器错误
        [self.loadingHUD changeState:HCWLoadingHUDLoadOther];
    });
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 加载完成
        [self.loadingHUD hidden];
    });
     */
}

#pragma mark - HCWLoadingHUDDelegate

- (void)loadingHUD:(HCWLoadingHUD *)hud tapBGWithType:(HCWLoadingHUDLoadState)state
{
    if (state == HCWLoadingHUDLoadOther) {
        [self.loadingHUD changeState:HCWLoadingHUDLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载错误
            [self.loadingHUD changeState:HCWLoadingHUDLoadError];
        });
    } else if (state == HCWLoadingHUDLoadError) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
