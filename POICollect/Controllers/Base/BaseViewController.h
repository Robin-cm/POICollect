//
//  BaseViewController.h
//  POICollect
//  所有的Viewcontroller的基类
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface BaseViewController : UIViewController

#pragma mark - 公共的实例方法

/**
 *  退出登录，并显示登录页面 
 */
- (void)logoutToLoginView;

/**
 *  退出一个新的视图控制器
 *
 *  @param targetVC 目标视图控制器
 *  @param params   要传递的参数
 */
- (void)pushVC:(UIViewController*)targetVC andParams:(id)params;

/**
 *  关闭当前的视图控制器
 *
 *  @param animation 是否有动画
 */
- (void)popViewControllerAnimated:(BOOL)animation;

@end
