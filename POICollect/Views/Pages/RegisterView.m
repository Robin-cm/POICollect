//
//  RegisterView.m
//  POICollect
//  注册页面
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "RegisterView.h"
#import "CMSimpleTextView.h"
#import "CMSimpleButton.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AIFNetworking.h"
#import "LoginViewController.h"
#import "UserRegistManager.h"
#import "UIView+Toast.h"
#import "UIDevice+IdentifierAddition.h"
#import "User.h"
#import "LoginUser.h"
#import "RegistUser.h"
#import "NSString+validator.h"

static const CGFloat padding = 20;

@interface RegisterView ()

@property (nonatomic, strong) LoginViewController* parentViewController;

@property (nonatomic, strong) CMSimpleTextView* registNameTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassCConfirmTextView;

@property (nonatomic, strong) CMSimpleButton* registBtn;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UIView* whiteBg;

@property (nonatomic, strong) UserRegistManager* userRegistManager;

@property (nonatomic, strong) RegistUser* registUser;

@end

@implementation RegisterView

#pragma mark - Getter

- (UserRegistManager*)userRegistManager
{
    if (!_userRegistManager) {
        _userRegistManager = [[UserRegistManager alloc] init];
        _userRegistManager.delegate = self;
        _userRegistManager.paramSource = self;
        _userRegistManager.validator = self;
    }
    return _userRegistManager;
}

- (RegistUser*)registUser
{
    if (!_registUser) {
        _registUser = [[RegistUser alloc] init];
    }
    return _registUser;
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
    [_registNameTextView resignFirstResponder];
    [_registPassTextView resignFirstResponder];
    [_registPassCConfirmTextView resignFirstResponder];
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

    if (!_registNameTextView) {
        _registNameTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"name_ico"] andWithPlaceholder:@"用户名" andWithInputType:CMSimpleTextFieldTypeUserName];
        _registNameTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _registNameTextView.borderWidth = 2;
        [_whiteBg addSubview:_registNameTextView];
    }

    if (!_registPassTextView) {
        _registPassTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"密码" andWithInputType:CMSimpleTextFieldTypePassword];
        _registPassTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _registPassTextView.borderWidth = 2;
        [_whiteBg addSubview:_registPassTextView];
    }

    if (!_registPassCConfirmTextView) {
        _registPassCConfirmTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"确认密码" andWithInputType:CMSimpleTextFieldTypePassword];
        _registPassCConfirmTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _registPassCConfirmTextView.borderWidth = 2;
        [_whiteBg addSubview:_registPassCConfirmTextView];
    }

    if (!_registBtn) {
        _registBtn = [[CMSimpleButton alloc] initSimpleButtonWithTitle:@"注册"];
        _registBtn.normalBorderColor = kAppThemeThirdColor;
        _registBtn.normalForegroundColor = [UIColor whiteColor];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _registBtn.normalBackgroundColor = kAppThemeThirdColor;
        _registBtn.highlightBackgroundColor = [kAppThemeThirdColor darkenedColorWithBrightnessFloat:0.8];
        [_registBtn addTarget:self action:@selector(registBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_whiteBg addSubview:_registBtn];
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
            make.top.equalTo(_registNameTextView.top).offset(-padding);
        }];
    }

    if (_registNameTextView) {
        [_registNameTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registPassTextView.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@40);
        }];
    }

    if (_registPassTextView) {
        [_registPassTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registPassCConfirmTextView.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@40);
        }];
    }

    if (_registPassCConfirmTextView) {
        [_registPassCConfirmTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registBtn.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@40);
        }];
    }

    if (_registBtn) {
        [_registBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.whiteBg.bottom).offset(-padding);
            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - 事件

- (void)registBtnTaped:(id)sender
{
    self.registUser.registName = _registNameTextView.text;
    self.registUser.registPass = _registPassTextView.text;
    self.registUser.registConformPass = _registPassCConfirmTextView.text;

    [_registNameTextView validate];
    [_registPassTextView validate];
    [_registPassCConfirmTextView validate];

    NSString* errStr = [self.registUser validateForm];
    if (![errStr isEqualToString:@""]) {
        [self.parentViewController.view makeToast:errStr];
        return;
    }

    if (!self.userRegistManager.isLoading) {
        _registBtn.enabled = NO;
        [self.userRegistManager loadData];
    }
}

#pragma mark - RTAPIManagerValidator

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithCallBackData:(NSDictionary*)data
{
    return YES;
}

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data
{
    if (![[data objectForKey:@"loginPwd"] isEqualToString:self.registUser.registConformPass]) {
        [self.parentViewController.view makeToast:@"密码不一致"];
        return NO;
    }
    if ([[data objectForKey:@"loginPwd"] isBlankString] || [[data objectForKey:@"loginName"] isBlankString]) {
        [self.parentViewController.view makeToast:@"用户名密码不能为空"];
        return NO;
    }
    return YES;
}

#pragma mark - RTAPIManagerParamSourceDelegate

- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager
{
    return @{
        @"loginName" : self.registUser.registName,
        @"loginPwd" : self.registUser.registPass
    };
}

#pragma mark - RTAPIManagerApiCallBackDelegate

- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager
{
    NSLog(@"成功返回数据");
    _registBtn.enabled = YES;
    [self.parentViewController.view hideToastActivity];
    if ([manager isKindOfClass:[UserRegistManager class]]) {
        NSDictionary* result = [manager fetchDataWithReformer:nil];
        NSLog(@"成功返回了数据了: %@", result);
        if ([[result objectForKey:@"success"] boolValue]) {
            //注册成功
            User* currentUser = [User userFromJson:[result objectForKey:@"obj"]];
            if (currentUser) {
                [LoginUser doLogin:[result objectForKey:@"obj"]];
            }
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            //注册失败
            [self.parentViewController.view makeToast:[result objectForKey:@"msg"]];
        }
    }
}

- (void)managerCallAPIDidFailed:(RTAPIBaseManager*)manager
{
    _registBtn.enabled = YES;
    [self.parentViewController.view hideToastActivity];
    [self.parentViewController.view makeToast:[NSString stringWithFormat:@"请求错误：%@", manager.errorMessage]];
    NSLog(@"请求失败 : %@", manager.errorMessage);
}

@end
