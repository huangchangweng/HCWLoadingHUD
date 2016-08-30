//
//  ThirdViewController.m
//  Example
//
//  Created by HCW on 16/8/30.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import "ThirdViewController.h"
#import "HCWLoadingHUD.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HCWLoadingHUD *loadingHUD = [HCWLoadingHUD showInViewController:self tapBlock:^(HCWLoadingHUD *hud, HCWLoadingHUDLoadState state) {
        [HCWLoadingHUD hiddenAllHUD:self];
    }];
    [loadingHUD setText:@"快速加载..." forState:HCWLoadingHUDLoading];
    [loadingHUD setActivityIndicatorAnimationType:DGActivityIndicatorAnimationTypeNineDots];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HCWLoadingHUD changeState:HCWLoadingHUDLoadOther inViewController:self];
    });
}



@end
