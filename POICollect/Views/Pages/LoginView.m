//
//  LoginView.m
//  POICollect
//  登录页面
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginView.h"
#import "UIView+CMExpened.h"
#import "CMSimpleTextView.h"
#import "CMSimpleButton.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "LoginViewController.h"
#import "LoginUser.h"
#import "UserLoginManager.h"
#import "UIView+Toast.h"
#import "UIDevice+IdentifierAddition.h"
#import "User.h"

static const CGFloat padding = 20;

@interface LoginView ()

@property (nonatomic, strong) LoginViewController* parentViewController;

@property (nonatomic, strong) CMSimpleTextView* loginNameTextView;

@property (nonatomic, strong) CMSimpleTextView* loginPassTextView;

@property (nonatomic, strong) CMSimpleButton* loginBtn;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;

@property (nonatomic, strong) UIView* whiteBg;

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) LoginUser* loginUser;

@property (nonatomic, strong) UserLoginManager* userLoginManager;

@end

@implementation LoginView

#pragma mark - Getter

- (LoginUser*)loginUser
{
    if (!_loginUser) {
        _loginUser = [[LoginUser alloc] init];
    }
    return _loginUser;
}

- (UserLoginManager*)userLoginManager
{
    if (!_userLoginManager) {
        _userLoginManager = [[UserLoginManager alloc] init];
        _userLoginManager.paramSource = self;
        _userLoginManager.validator = self;
        _userLoginManager.delegate = self;
    }
    return _userLoginManager;
}

#pragma mark - 生命周期

- (instancetype)initWithParentViewController:(LoginViewController*)parentViewController
{
    self = [super init];
    if (self) {
        _parentViewController = parentViewController;
        self.backgroundColor = [UIColor clearColor];
        [self configView];
        [self layoutView];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CloseKeyBoard;
}

#pragma mark - 自定义方法

- (void)configView
{
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
        [self addSubview:_scrollView];
    }

    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_scrollView addSubview:_contentView];
    }

    if (!_whiteBg) {
        _whiteBg = [[UIView alloc] init];
        _whiteBg.backgroundColor = [UIColor colorWithHexString:@"0xf7f7f7"];
        [_contentView addSubview:_whiteBg];
    }

    if (!_loginNameTextView) {
        _loginNameTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"name_ico"] andWithPlaceholder:@"用户名" andWithInputType:CMSimpleTextFieldTypeUserName];
        _loginNameTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _loginNameTextView.borderWidth = 2;
        _loginNameTextView.foucsBorderWidth = 2;
        [_whiteBg addSubview:_loginNameTextView];
    }
    if (!_loginPassTextView) {
        _loginPassTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"密码" andWithInputType:CMSimpleTextFieldTypePassword];
        _loginPassTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _loginPassTextView.borderWidth = 2;
        _loginPassTextView.foucsBorderWidth = 2;
        [_whiteBg addSubview:_loginPassTextView];
    }
    if (!_loginBtn) {
        _loginBtn = [[CMSimpleButton alloc] initSimpleButtonWithTitle:@"登陆"];
        _loginBtn.normalBorderColor = kAppThemeThirdColor;
        _loginBtn.normalForegroundColor = [UIColor whiteColor];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _loginBtn.normalBackgroundColor = kAppThemeThirdColor;
        _loginBtn.highlightBackgroundColor = [kAppThemeThirdColor darkenedColorWithBrightnessFloat:0.8];
        [_loginBtn addTarget:self action:@selector(loginBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_whiteBg addSubview:_loginBtn];
    }
}

- (void)layoutView
{
    __weak typeof(self) weakSelf = self;

    if (_scrollView) {
        [_scrollView makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(weakSelf);
        }];
    }

    if (_contentView) {
        [_contentView makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(weakSelf.scrollView);
            make.width.equalTo(weakSelf.scrollView);
            make.height.equalTo(weakSelf.scrollView);
            make.left.equalTo(weakSelf.scrollView.left);
            make.top.equalTo(weakSelf.scrollView.top);
        }];
    }

    if (_whiteBg) {
        [_whiteBg makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView.bottom);
            make.top.equalTo(_loginNameTextView.top).offset(-padding);
        }];
    }

    if (_loginNameTextView) {
        [_loginNameTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.loginPassTextView.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@40);
        }];
    }

    if (_loginPassTextView) {
        [_loginPassTextView makeConstraints:^(MASConstraintMaker* make) {
            //            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.loginBtn.top).offset(-padding);
            make.height.equalTo(@40);
        }];
    }

    if (_loginBtn) {
        [_loginBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.whiteBg.bottom).offset(-padding);
            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - 事件

- (void)loginBtnTaped:(id)sender
{
    NSLog(@"点击登录了");
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kDefaultDoneNotifacitionidentifier object:nil];

    self.loginUser.loginName = _loginNameTextView.text;
    self.loginUser.loginPass = _loginPassTextView.text;

    [_loginNameTextView validate];
    [_loginPassTextView validate];

    NSString* errStr
        = [self.loginUser validateForm];
    if (![errStr isEqualToString:@""]) {
        [self.parentViewController.view makeToast:errStr];
        return;
    }

    //验证通过
    _loginBtn.enabled = NO;
    //关闭键盘
    CloseKeyBoard;

    [self.parentViewController.view makeToastActivity];
    [self.userLoginManager loadData];
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

    if ([[data objectForKey:@"loginName"] isEqualToString:@""] || [[data objectForKey:@"loginPass"] isEqualToString:@""]) {
        [self.parentViewController.view makeToast:@"用户名密码不能为空"];
        return NO;
    }
    return YES;
}

#pragma marl - RTAPIManagerParamSourceDelegate

- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager
{
    return @{
        @"loginName" : self.loginUser.loginName,
        @"loginPwd" : self.loginUser.loginPass,
        @"clientid" : [UIDevice identifierForVendor]
    };
}

#pragma mark - RTAPIManagerApiCallBackDelegate

- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager
{

    NSLog(@"成功返回数据");
    _loginBtn.enabled = YES;
    [self.parentViewController.view hideToastActivity];
    if ([manager isKindOfClass:[UserLoginManager class]]) {
        NSDictionary* result = [manager fetchDataWithReformer:nil];
        NSLog(@"成功返回了数据了: %@", result);
        if ([[result objectForKey:@"success"] boolValue]) {
            //登录成功
            User* currentUser = [User userFromJson:[result objectForKey:@"obj"]];
            if (currentUser) {
                [LoginUser doLogin:[result objectForKey:@"obj"]];
            }
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            //登录失败
            [self.parentViewController.view makeToast:[result objectForKey:@"msg"]];
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
    _loginBtn.enabled = YES;
    [self.parentViewController.view hideToastActivity];
    [self.parentViewController.view makeToast:[NSString stringWithFormat:@"请求错误：%@", manager.errorMessage]];
    NSLog(@"请求失败 : %@", manager.errorMessage);
}

@end
