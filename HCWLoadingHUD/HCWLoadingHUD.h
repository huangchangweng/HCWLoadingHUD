//
//  HCWLoadingHUD.h
//  Example
//
//  Created by HCW on 16/8/30.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"

typedef NS_ENUM(NSUInteger,HCWLoadingHUDLoadState){
    HCWLoadingHUDLoading,   /**< 加载中 */
    HCWLoadingHUDLoadOther, /**< 其它 */
    HCWLoadingHUDLoadError, /**< 错误 */
};

@class HCWLoadingHUD;
@protocol HCWLoadingHUDDelegate <NSObject>
/**
 *  点击背景回调
 *  hud: self
 *  state: 状态
 */
- (void)loadingHUD:(HCWLoadingHUD *)hud tapBGWithType:(HCWLoadingHUDLoadState)state;
@end

typedef void(^HCWLoadingHUDTapBlock)(HCWLoadingHUD *hud, HCWLoadingHUDLoadState state);

@interface HCWLoadingHUD : UIViewController

@property (nonatomic, weak) id<HCWLoadingHUDDelegate> delegate;

- (void)setText:(NSString *)text forState:(HCWLoadingHUDLoadState)state;
- (void)setTextColor:(UIColor *)textColor forState:(HCWLoadingHUDLoadState)state;
- (void)setImage:(UIImage *)image forState:(HCWLoadingHUDLoadState)state;
- (void)setActivityIndicatorAnimationType:(DGActivityIndicatorAnimationType)animationType;
- (void)backgroundColor:(UIColor *)color;
- (void)textFont:(UIFont *)font;

- (void)showInViewController:(UIViewController *)vc;
- (void)changeState:(HCWLoadingHUDLoadState)state;
- (void)hidden;

+ (HCWLoadingHUD *)showInViewController:(UIViewController *)vc;
+ (HCWLoadingHUD *)showInViewController:(UIViewController *)vc tapBlock:(HCWLoadingHUDTapBlock)tapBlock;
+ (void)changeState:(HCWLoadingHUDLoadState)state inViewController:(UIViewController *)vc;
+ (void)hiddenAllHUD:(UIViewController *)vc;
@end
