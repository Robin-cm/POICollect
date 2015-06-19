//
//  BaseViewController.m
//  POICollect
//
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kAppBackgroundColor;
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
}

/**
 *  关闭当前的视图控制器
 *
 *  @param animation 是否有动画
 */
- (void)popViewControllerAnimated:(BOOL)animation
{
}

@end
