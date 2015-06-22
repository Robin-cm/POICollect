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

static const CGFloat padding = 20;

@interface LoginView () {
    UIView* _firstLine;

    UIView* _secendLine;
}

@property (nonatomic, strong) CMSimpleTextView* loginNameTextView;

@property (nonatomic, strong) CMSimpleTextView* loginPassTextView;

@property (nonatomic, strong) UILabel* loginNameLabel;

@property (nonatomic, strong) UILabel* loginPassLabel;

@property (nonatomic, strong) CMSimpleButton* loginBtn;

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
    if (_loginNameLabel) {
        [_loginNameLabel makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.top).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(_loginNameTextView.left).offset(-padding);
            make.height.equalTo(@35);
            make.width.equalTo(@60);
        }];
    }

    if (_loginNameTextView) {
        [_loginNameTextView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.top).offset(padding);
            make.left.equalTo(_loginNameLabel.right).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_firstLine) {
        [_firstLine makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(_loginNameLabel.bottom).offset(padding);
        }];
    }

    if (_loginPassLabel) {
        [_loginPassLabel makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(_loginPassTextView.left).offset(-padding);
            make.height.equalTo(@35);
            make.width.equalTo(@60);
        }];
    }

    if (_loginPassTextView) {
        [_loginPassTextView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(_loginPassLabel.right).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_secendLine) {
        [_secendLine makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(_loginPassLabel.bottom).offset(padding);
        }];
    }

    if (_loginBtn) {
        [_loginBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.left).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.top.equalTo(_secendLine.bottom).offset(padding);
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
    if (!_firstLine) {
        _firstLine = [[UIView alloc] init];
        _firstLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_firstLine];
    }
    if (!_secendLine) {
        _secendLine = [[UIView alloc] init];
        _secendLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_secendLine];
    }

    if (!_loginNameLabel) {
        _loginNameLabel = [[UILabel alloc] init];
        _loginNameLabel.textColor = [UIColor lightGrayColor];
        _loginNameLabel.text = @"用户名";
        _loginNameLabel.textAlignment = NSTextAlignmentJustified;
        [self addSubview:_loginNameLabel];
    }
    if (!_loginNameTextView) {
        _loginNameTextView = [[CMSimpleTextView alloc] initWithPlaceholder:@"用户名..."];
        [self addSubview:_loginNameTextView];
    }
    if (!_loginPassLabel) {
        _loginPassLabel = [[UILabel alloc] init];
        _loginPassLabel.textAlignment = NSTextAlignmentJustified;
        _loginPassLabel.textColor = [UIColor lightGrayColor];
        _loginPassLabel.text = @"密    码";
        [self addSubview:_loginPassLabel];
    }
    if (!_loginPassTextView) {
        _loginPassTextView = [[CMSimpleTextView alloc] initWithPlaceholder:@"密码..."];
        [self addSubview:_loginPassTextView];
    }
    if (!_loginBtn) {
        _loginBtn = [[CMSimpleButton alloc] initSimpleButtonWithTitle:@"登陆"];
        [self addSubview:_loginBtn];
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
