//
//  SettingViewController.m
//  POICollect
//  个人设置页面
//  Created by 常敏 on 15/7/13.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "SettingViewController.h"
#import "CMImageHeaderView.h"
#import "CMSimpleButton.h"
#import "UITableView+Expanded.h"
#import "AboutUsViewController.h"
#import "UserLogoutManager.h"
#import "UIView+Toast.h"
#import "LoginUser.h"
#import "TdtWebViewController.h"

static const CGFloat headerViewHeight = 300;

#define kCellIdentifier @"kCellIdentifier"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, RTAPIManagerApiCallBackDelegate, RTAPIManagerParamSourceDelegate, RTAPIManagerValidator>

@property (strong, nonatomic) UITableView* mTableView;

@property (nonatomic, assign) BOOL showNav;

@property (nonatomic, assign) CGFloat difference1;

@property (nonatomic, assign) CGFloat difference2;

@property (nonatomic, strong) UserLogoutManager* userLogoutManager;

@property (nonatomic, assign) BOOL isScrollUp;

@end

@implementation SettingViewController

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
    [(CMImageHeaderView*)self.mTableView.tableHeaderView refreshBlurViewForNewImage];
    [self setNavigationBarTranslucent:YES];
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Setter

- (void)setShowNav:(BOOL)showNav
{
    if (_showNav == showNav) {
        return;
    }
    _showNav = showNav;
    [self setNavigationBarTranslucent:!_showNav];
}

#pragma mark - Getter

- (UserLogoutManager*)userLogoutManager
{
    if (!_userLogoutManager) {
        _userLogoutManager = [[UserLogoutManager alloc] init];
        _userLogoutManager.delegate = self;
        _userLogoutManager.paramSource = self;
        _userLogoutManager.validator = self;
    }
    return _userLogoutManager;
}

#pragma mark - 初始化

- (void)configView
{

    [self configTitle];

    self.view.backgroundColor = [UIColor whiteColor];

    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
        [self.view addSubview:_mTableView];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
    }

    CMImageHeaderView* headerView = [CMImageHeaderView cmImageHeaderViewWithImage:[UIImage imageNamed:@"main_bg"] forSize:CGSizeMake(kScreenWidth, headerViewHeight)];
    headerView.headerTitleLabel.text = @"欢迎您";

    [self.mTableView setTableHeaderView:headerView];
    [self.mTableView setTableFooterView:[self customFooterView]];
}

- (void)configTitle
{
    [self setNavigationBarTranslucent:YES];
    UIBarButtonItem* closeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnTaped:)];
    self.navigationItem.leftBarButtonItem = closeBtn;
}

#pragma mark - 事件

- (void)closeBtnTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginBtnTaped:(id)sender
{
    if (![self.userLogoutManager isLoading]) {
        [self.view makeToastActivity];
        [self.userLogoutManager loadData];
    }
}

#pragma mark - 自定义方法

- (UITableViewCell*)customCellForIndex:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = nil;
    cell = [self.mTableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    switch (indexPath.row) {
    case 0:
        cell.textLabel.text = @"关于";
        break;
    case 1:
        cell.textLabel.text = @"天地图(天津)";
        break;

    default:
        break;
    }

    return cell;
}

- (UIView*)customFooterView
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    CMSimpleButton* logoutBtn = [[CMSimpleButton alloc] initSimpleButtonWithTitle:@"注销"];
    logoutBtn.frame = CGRectMake(10, 0, kScreenWidth - 20, 35);
    logoutBtn.normalBorderColor = kAppThemeThirdColor;
    logoutBtn.normalForegroundColor = [UIColor whiteColor];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    logoutBtn.normalBackgroundColor = kAppThemeThirdColor;
    logoutBtn.highlightBackgroundColor = [kAppThemeThirdColor darkenedColorWithBrightnessFloat:0.8];
    [logoutBtn addTarget:self action:@selector(loginBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.center = footerView.center;
    [footerView addSubview:logoutBtn];

    return footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self customCellForIndex:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:18];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return 50;
//}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
    case 0: {
        //点击关于
        AboutUsViewController* aboutVC = [[AboutUsViewController alloc] init];
        [self pushVC:aboutVC andParams:nil];

        break;
    }
    case 1: {
        //点击天地图
        TdtWebViewController* tdtVC = [[TdtWebViewController alloc] init];
        [self pushVC:tdtVC andParams:nil];
        break;
    }

    default:
        break;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    CGFloat contentOffSet = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;

    _difference1 = contentHeight - contentOffSet;

    if (_difference1 > _difference2) {
        _isScrollUp = NO;
    }
    else {
        _isScrollUp = YES;
    }

    _difference2 = contentHeight - contentOffSet;

    if (scrollView == self.mTableView) {
        [(CMImageHeaderView*)self.mTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];

        if (_isScrollUp) {
            if (scrollView.contentOffset.y > (headerViewHeight - kStateBarHeight - kNavBarHeight)) {
                self.showNav = YES;
            }
            else {
                self.showNav = NO;
            }
        }
        else {
            if (scrollView.contentOffset.y < headerViewHeight) {
                self.showNav = NO;
            }
            else {
                self.showNav = YES;
            }
        }
    }
}

#pragma mark - RTAPIManagerApiCallBackDelegate

/**
 *  请求成功回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager
{
    NSLog(@"成功返回数据");
    [self.view hideToastActivity];
    if ([manager isKindOfClass:[UserLogoutManager class]]) {
        NSDictionary* result = [manager fetchDataWithReformer:nil];
        NSLog(@"成功返回了数据了: %@", result);
        if ([[result objectForKey:@"success"] boolValue]) {
            //注销成功
            [LoginUser doLogout];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self checkIslogin];
        }
        else {
            //注销失败
            [self.view makeToast:[result objectForKey:@"msg"]];
        }
    }
}

/**
 *  请求失败回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidFailed:(RTAPIBaseManager*)manager
{
    [self.view hideToastActivity];
    [self.view makeToast:[NSString stringWithFormat:@"请求错误：%@", manager.errorMessage]];
    NSLog(@"请求失败 : %@", manager.errorMessage);
}

#pragma mark - RTAPIManagerParamSourceDelegate

/**
 *  获取请求的参数字典
 *
 *  @param manager manager对象
 *
 *  @return 返回的参数的字典
 */
- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager
{
    if ([manager isKindOfClass:[UserLogoutManager class]]) {
        User* currentUser = [LoginUser currentLoginUser];
        return @{
            @"userId" : currentUser.userId,
            @"token" : currentUser.toKen
        };
    }
    return @{};
}

#pragma mark - RTAPIManagerValidator

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithCallBackData:(NSDictionary*)data
{

    return YES;
}

/**
 *  验证请求的参数的方法。当调用API的参数是来自用户输入的时候，验证时必要的。
 *  当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。
 *
 *  @param manager manager对象
 *  @param data    参数的字典数据
 *
 *  @return 是否验证通过
 */
- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data
{
    return YES;
}

@end
