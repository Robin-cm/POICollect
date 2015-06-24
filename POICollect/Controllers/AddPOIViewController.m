//
//  AddPOIViewController.m
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AddPOIViewController.h"

@interface AddPOIViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation AddPOIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor redColor];
    [self initializeData];
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法

- (void)initializeData
{
}

- (void)initializeView
{
    [self initializeTitle];
    [self initializeBody];
}

- (void)initializeTitle
{
    [self setNavigationBarTranslucent:YES];
    [self showBackgroundImage:YES];
}

- (void)initializeBody
{
    __weak typeof(self) weakSelf = self;
    UIView* mainBgView = [[UIView alloc] init];
    mainBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainBgView];
    [mainBgView makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(((UIView*)weakSelf.topLayoutGuide).bottom);
        make.left.and.right.and.bottom.equalTo(weakSelf.view);
    }];

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
    }
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
