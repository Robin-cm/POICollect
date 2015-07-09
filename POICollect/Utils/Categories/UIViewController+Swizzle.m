//
//  UIViewController+Swizzle.m
//  POICollect
//
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "ObjcRuntime.h"

@implementation UIViewController (Swizzle)

#pragma mark - 方法

- (void)customViewDidLoad
{
    if (!self.navigationItem.leftBarButtonItem && self.navigationController.viewControllers.count > 1 && !kHigher_iOS_6_1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self backButton]];
    }
    [self customViewDidLoad];
}

- (void)customViewWillDisappear:(BOOL)animated
{
    if (!self.navigationItem.backBarButtonItem && self.navigationController.viewControllers.count > 1 && kHigher_iOS_6_1) {
        [self backButton_higherOS];
    }
    [self customViewWillDisappear:animated];
}

- (void)customViewWillAppear:(BOOL)animated
{
    [self customViewWillAppear:animated];
}

#pragma mark - 按钮

- (UIButton*)backButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* buttonImage = [UIImage imageNamed:@"nav_back"];
    button.frame = CGRectMake(0, 0, 55, 30);
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [button addTarget:self action:@selector(gaBack_Swizzle) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)backButton_higherOS
{
    UIImage* backButtonImage = [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 按钮点击事件

- (void)gaBack_Swizzle
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/**
 *  交换所有的ViewController的一些方法
 */
void swizzleAllViewController()
{
    Swizzle([UIViewController class], @selector(viewDidLoad), @selector(customViewDidLoad));
    Swizzle([UIViewController class], @selector(viewWillDisappear:), @selector(customViewWillDisappear:));
    Swizzle([UIViewController class], @selector(viewWillAppear:), @selector(customViewWillAppear:));
}
