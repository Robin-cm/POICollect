//
//  SelectLocationModelViewController.m
//  POICollect
//
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "SelectLocationViewController.h"

#import "SelectLocationModelViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SelectLocationModelViewController ()

@property (nonatomic, strong) SelectLocationViewController* selectVC;

@end

@implementation SelectLocationModelViewController

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

#pragma mark - Setter

#pragma mark - 初始化子视图

- (void)configView
{
    if (!_selectVC) {
        _selectVC = [[SelectLocationViewController alloc] init];
    }
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:_selectVC];
    navVC.view.frame = self.view.bounds;
    [self addChildViewController:navVC];
    [self.view addSubview:navVC.view];
}

- (void)configNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeModel:) name:kDefaultSelectedNotifacitionidentifier object:nil];
    });
}

- (void)closeModel:(NSNotification*)notification
{
    if (notification.userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectVC:didSelectLocation:)]) {
                [self.delegate selectVC:self didSelectLocation:notification.userInfo];
            }

        });
    }
}

@end
