//
//  HCWLoadingHUD.m
//  Example
//
//  Created by HCW on 16/8/30.
//  Copyright © 2016年 HCW. All rights reserved.
//

#define kHCWLoadingHUDTextColor [UIColor grayColor]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "HCWLoadingHUD.h"
#import <Foundation/Foundation.h>

static const CGFloat kHCWLoadingHUDTextDefaultSize = 14.0f;

@interface HCWLoadingHUD ()
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) NSString *loadingText;
@property (nonatomic, strong) NSString *otherText;
@property (nonatomic, strong) NSString *errorText;
@property (nonatomic, strong) UIColor *loadingTextColor;
@property (nonatomic, strong) UIColor *otherTextColor;
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIImage *otherImage;
@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, assign) DGActivityIndicatorAnimationType *animationType;

@property (nonatomic, assign) HCWLoadingHUDLoadState state;
@property (nonatomic, strong) UIViewController *inViewController;
@property (nonatomic, strong) HCWLoadingHUDTapBlock tapBlock;
@end

@implementation HCWLoadingHUD

- (instancetype)init {
    if (self = [super init]) {
        _loadingText = @"加载中...";
        _otherText = @"没有找到数据";
        _errorText = @"网络错误，请检查您的网络";
        _loadingTextColor = kHCWLoadingHUDTextColor;
        _otherTextColor = kHCWLoadingHUDTextColor;
        _errorTextColor = kHCWLoadingHUDTextColor;
        _otherImage = [UIImage imageNamed:@"HCWLoadingHUD.bundle/info"];
        _errorImage = [UIImage imageNamed:@"HCWLoadingHUD.bundle/error"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.stateImageView];
    [self.view addSubview:self.activityIndicatorView];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self registerForKVO];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 40)/2, self.view.frame.size.height/2-40, 40, 40);
    self.stateImageView.frame = CGRectMake((self.view.frame.size.width - 40)/2, self.view.frame.size.height/2-40, 40, 40);
    
    self.stateLabel.frame = CGRectMake(20,(self.activityIndicatorView.frame.origin.y+self.activityIndicatorView.frame.size.height)+20, self.view.frame.size.width-40, [self.stateLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-20, 0)].height);
}

- (void)dealloc {
    [self unregisterFromKVO];
    NSLog(@"HCWLoadingHUD dealloc");
}

#pragma mark - Private Method

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"loadingText", @"otherText", @"errorText", @"loadingTextColor",@"otherTextColor", @"errorTextColor", @"otherImage", @"errorImage", @"animationType", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"loadingText"]) {
        self.stateLabel.text = self.loadingText;
    } else if ([keyPath isEqualToString:@"otherText"]) {
        self.stateLabel.text = self.otherText;
    } else if ([keyPath isEqualToString:@"errorText"]) {
        self.stateLabel.text = self.errorText;
    } else if ([keyPath isEqualToString:@"loadingTextColor"]) {
        self.stateLabel.textColor = self.loadingTextColor;
    } else if ([keyPath isEqualToString:@"otherTextColor"]) {
        self.stateLabel.textColor = self.otherTextColor;
    } else if ([keyPath isEqualToString:@"errorTextColor"]) {
        self.stateLabel.textColor = self.errorTextColor;
    } else if ([keyPath isEqualToString:@"otherImage"]) {
        self.stateImageView.image = self.otherImage;
    } else if ([keyPath isEqualToString:@"errorImage"]) {
        self.stateImageView.image = self.errorImage;
    } else if ([keyPath isEqualToString:@"animationType"]) {
        self.activityIndicatorView.type = (int)self.animationType;
    }
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
}

#pragma mark - Response Event

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(loadingHUD:tapBGWithType:)]) {
        [self.delegate loadingHUD:self tapBGWithType:self.state];
    }
    if (self.tapBlock) {
        __weak typeof(self) weakSelf = self;
        weakSelf.tapBlock(weakSelf, weakSelf.state);
    }
}

#pragma mark - Public Method

- (void)setText:(NSString *)text forState:(HCWLoadingHUDLoadState)state
{
    switch ((int)state) {
        case HCWLoadingHUDLoading:
            self.loadingText = text;
            break;
        case HCWLoadingHUDLoadOther:
            self.otherText = text;
            break;
        case HCWLoadingHUDLoadError:
            self.errorText = text;
            break;
    }
}

- (void)setTextColor:(UIColor *)textColor forState:(HCWLoadingHUDLoadState)state
{
    switch ((int)state) {
        case HCWLoadingHUDLoading:
            self.loadingTextColor = textColor;
            break;
        case HCWLoadingHUDLoadOther:
            self.otherTextColor = textColor;
            break;
        case HCWLoadingHUDLoadError:
            self.errorTextColor = textColor;
            break;
    }
}

- (void)setImage:(UIImage *)image forState:(HCWLoadingHUDLoadState)state
{
    switch ((int)state) {
        case HCWLoadingHUDLoadOther:
            self.otherImage = image;
            break;
        case HCWLoadingHUDLoadError:
            self.errorImage = image;
            break;
    }
}

- (void)setActivityIndicatorAnimationType:(DGActivityIndicatorAnimationType)animationType
{
    self.activityIndicatorView.type = animationType;
}

- (void)backgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)textFont:(UIFont *)font
{
    self.stateLabel.font = font;
}

- (void)showInViewController:(UIViewController *)vc
{
    [HCWLoadingHUD hiddenAllHUD:vc];
    self.view.bounds = vc.view.bounds;
    [self removeFromParentViewController];
    [vc addChildViewController:self];
    [vc.view addSubview:self.view];
    [self changeState:HCWLoadingHUDLoading];
}

- (void)changeState:(HCWLoadingHUDLoadState)state
{
    self.state = state;
    switch ((int)self.state) {
        case HCWLoadingHUDLoading:
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
            self.stateImageView.hidden = YES;
            self.stateLabel.text = self.loadingText;
            self.stateLabel.textColor = self.loadingTextColor;
            break;
        case HCWLoadingHUDLoadOther:
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
            self.stateImageView.hidden = NO;
            self.stateLabel.text = self.otherText;
            self.stateImageView.image = self.otherImage;
            self.stateLabel.textColor = self.otherTextColor;
            break;
        case HCWLoadingHUDLoadError:
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
            self.stateImageView.hidden = NO;
            self.stateLabel.text = self.errorText;
            self.stateImageView.image = self.errorImage;
            self.stateLabel.textColor = self.errorTextColor;
            break;
    }
}

- (void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}

+ (HCWLoadingHUD *)showInViewController:(UIViewController *)vc
{
    return [self showInViewController:vc tapBlock:NULL];
}

+ (HCWLoadingHUD *)showInViewController:(UIViewController *)vc tapBlock:(HCWLoadingHUDTapBlock)tapBlock
{
    [self hiddenAllHUD:vc];
    HCWLoadingHUD *loadingHUD = [HCWLoadingHUD new];
    loadingHUD.tapBlock = tapBlock;
    [loadingHUD showInViewController:vc];
    
    return loadingHUD;
}

+ (void)changeState:(HCWLoadingHUDLoadState)state inViewController:(UIViewController *)vc
{
    for (UIViewController *viewController in vc.childViewControllers) {
        if ([viewController isKindOfClass:[HCWLoadingHUD class]]) {
            HCWLoadingHUD *loadingVC = (HCWLoadingHUD *)viewController;
            [loadingVC changeState:state];
        }
    }
}

+(void)hiddenAllHUD:(UIViewController *)vc
{
    for (UIViewController *viewController in vc.childViewControllers) {
        if ([viewController isKindOfClass:[HCWLoadingHUD class]]) {
            HCWLoadingHUD *loadingVC = (HCWLoadingHUD *)viewController;
            [loadingVC.view removeFromSuperview];
            [loadingVC removeFromParentViewController];
        }
    }
}

#pragma mark - Getter

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:kHCWLoadingHUDTextDefaultSize];
        _stateLabel.textColor = kHCWLoadingHUDTextColor;
        _stateLabel.numberOfLines = 0;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UIImageView *)stateImageView
{
    if (!_stateImageView) {
        _stateImageView = [UIImageView new];
        _stateImageView.contentMode = UIViewContentModeScaleAspectFit;
        _stateImageView.hidden = YES;
    }
    return _stateImageView;
}

- (DGActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:kHCWLoadingHUDTextColor];
    }
    return _activityIndicatorView;
}

@end
