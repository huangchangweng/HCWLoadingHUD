# HCWLoadingHUD
ViewController网络加载遮罩，有加载失败，没有数据等状态。使用简单

![image](https://github.com/huangchangweng/HCWLoadingHUD/blob/master/HCWLoadingHUD.gif)

## 使用方法
### 1.property方式
    self.loadingHUD = [HCWLoadingHUD new];
    self.loadingHUD.delegate = self;
    [self.loadingHUD setText:@"服务器错误点击屏幕重新加载" forState:HCWLoadingHUDLoadOther];
    [self.loadingHUD setText:@"未知错误点击屏幕返回" forState:HCWLoadingHUDLoadError];
    [self.loadingHUD showInViewController:self];
  
### 2.使用静态方法
    HCWLoadingHUD *loadingHUD = [HCWLoadingHUD showInViewController:self tapBlock:^(HCWLoadingHUD *hud, HCWLoadingHUDLoadState state) {
        [HCWLoadingHUD hiddenAllHUD:self];
    }];
    [loadingHUD setText:@"快速加载..." forState:HCWLoadingHUDLoading];
    [loadingHUD setActivityIndicatorAnimationType:DGActivityIndicatorAnimationTypeNineDots];
    
第一种方法适用于单个ViewController添加遮罩，也可用于BaseViewController，但不推荐使用。推荐第二种适用于封装全部ViewController的遮罩。

作者：HCW
联系方式：599139419@qq.com
使用中如有疑问或有建议，欢迎打扰！
