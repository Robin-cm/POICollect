//
//  LoginModelViewController.m
//  POICollect
//
//  Created by 常敏 on 15/6/30.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginModelViewController.h"
#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginModelViewController ()

@end

@implementation LoginModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [self configNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化子视图

- (void)configView
{
    LoginViewController* loginVC = [[LoginViewController alloc] init];
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navVC.view.frame = self.view.bounds;
    [self addChildViewController:navVC];
    [self.view addSubview:navVC.view];
}


- (void)configNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeModel:) name:kDefaultDoneNotifacitionidentifier object:nil];
}

- (void) closeModel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
