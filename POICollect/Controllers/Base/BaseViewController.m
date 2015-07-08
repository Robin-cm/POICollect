//
//  BaseViewController.m
//  POICollect
//
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModelViewController.h"
#import "LoginUser.h"
#import "UIImage+Expanded.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIImageView* bgImgView;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = kAppBackgroundColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarTranslucent:(BOOL)isTranslucent
{
    if (isTranslucent) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        self.navigationController.navigationBar.barTintColor = kAppThemePrimaryColor;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)showBackgroundImage:(BOOL)isShow
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"main_bg"];
        _bgImgView.contentMode = UIViewContentModeScaleToFill;
        //        [self.view insertSubview:_bgImgView
        //                         atIndex:0];
        [self.view addSubview:_bgImgView];
    }
    [_bgImgView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 实例方法

/**
 *  退出登录，并显示登录页面
 */
- (void)logoutToLoginView
{
}

/**
 *  退出一个新的视图控制器
 *
 *  @param targetVC 目标视图控制器
 *  @param params   要传递的参数
 */
- (void)pushVC:(UIViewController*)targetVC andParams:(id)params
{
    if (self.navigationController) {
        [self.navigationController pushViewController:targetVC animated:YES];
    }
}

/**
 *  关闭当前的视图控制器
 *
 *  @param animation 是否有动画
 */
- (void)popViewControllerAnimated:(BOOL)animation
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animation];
    }
}

/**
 *  检查是不是登陆了
 */
- (void)checkIslogin
{
    //    if (![LoginUser isLogin]) {
    //        [self sendToLogin];
    //    }
}

/**
 *  去到登陆页面
 */
- (void)sendToLogin
{
    //    [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:[[LoginModelViewController alloc] init] animated:YES completion:nil];
    ShowModelViewController([[LoginModelViewController alloc] init]);
}

@end
