//
//  TestTableViewController.m
//  POICollect
//
//  Created by 常敏 on 15/7/15.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "TestTableViewController.h"
#import "UITableView+Expanded.h"
#import "UIButton+Bootstrap.h"

#define kTableViewCellIdentifier @"kTableViewCellIdentifier"

@interface TestTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation TestTableViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Getter

- (UITableView*)tableView
{
    if (!_tableView) {
        CGRect frame = kScreenBounds;
        frame.size.height -= (kNavBarHeight + kStateBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
        [_tableView setTableFooterView:[self getFooterView]];
    }
    return _tableView;
}

#pragma mark - 自定义

- (void)configView
{
    [self.view addSubview:self.tableView];
}

- (UIView*)getFooterView
{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];

    UIButton* footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 35)];
    [footerBtn successStyle];
    footerBtn.enabled = NO;
    [footerBtn setTitle:@"测试按钮" forState:UIControlStateNormal];
    [footerBtn addAwesomeIcon:FAIconOk beforeTitle:YES];
    [contentView addSubview:footerBtn];
    return contentView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    NSLog(@"backgroundView -------->  %@", cell.backgroundView);
    //    cell.contentView.backgroundColor = [UIColor redColor];
    //    cell.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    //    cell.textLabel.layer.borderWidth = 1.f;
    cell.textLabel.text = @"asdasdasd";
    [tableView addLineForPlainCell:cell forRowAtIndexPath:indexPath withLineColor:[UIColor lightGrayColor] withLeftSpace:20];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

@end
