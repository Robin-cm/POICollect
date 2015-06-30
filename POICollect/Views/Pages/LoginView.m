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

static const CGFloat padding = 20;

@interface LoginView () {
}

@property (nonatomic, strong) CMSimpleTextView* loginNameTextView;

@property (nonatomic, strong) CMSimpleTextView* loginPassTextView;

@property (nonatomic, strong) CMSimpleButton* loginBtn;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;

@property (nonatomic, strong) UIView* whiteBg;

@property (nonatomic, strong) UIView* contentView;

@end

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configView];
    }
    return self;
}

- (void)layoutSubviews
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
            make.height.equalTo(@35);
        }];
    }

    if (_loginPassTextView) {
        [_loginPassTextView makeConstraints:^(MASConstraintMaker* make) {
            //            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.loginBtn.top).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_loginBtn) {
        [_loginBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.whiteBg.bottom).offset(-padding);
            make.height.equalTo(@35);
        }];
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [_loginNameTextView resignFirstResponder];
    [_loginPassTextView resignFirstResponder];
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
        _loginNameTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"name_ico"] andWithPlaceholder:@"用户名" andWithInputType:Email];
        _loginNameTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _loginNameTextView.borderWidth = 2;
        _loginNameTextView.foucsBorderWidth = 2;
        [_whiteBg addSubview:_loginNameTextView];
    }
    if (!_loginPassTextView) {
        _loginPassTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"密码" andWithInputType:Password];
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
        [_whiteBg addSubview:_loginBtn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
