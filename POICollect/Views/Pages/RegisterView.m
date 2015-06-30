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

static const CGFloat padding = 20;

@interface RegisterView () {
}

@property (nonatomic, strong) CMSimpleTextView* registNameTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassCConfirmTextView;

@property (nonatomic, strong) CMSimpleButton* registBtn;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UIView* whiteBg;

@end

@implementation RegisterView

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
            make.top.equalTo(_registNameTextView.top).offset(-padding);
        }];
    }

    if (_registNameTextView) {
        [_registNameTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registPassTextView.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_registPassTextView) {
        [_registPassTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registPassCConfirmTextView.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_registPassCConfirmTextView) {
        [_registPassCConfirmTextView makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(weakSelf.registBtn.top).offset(-padding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_registBtn) {
        [_registBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.whiteBg.left).offset(padding);
            make.right.equalTo(weakSelf.whiteBg.right).offset(-padding);
            make.bottom.equalTo(weakSelf.whiteBg.bottom).offset(-padding);
            make.height.equalTo(@35);
        }];
    }
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
        _registNameTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"name_ico"] andWithPlaceholder:@"用户名" andWithInputType:Email];
        _registNameTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _registNameTextView.borderWidth = 2;
        [_whiteBg addSubview:_registNameTextView];
    }

    if (!_registPassTextView) {
        _registPassTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"密码" andWithInputType:Email];
        _registPassTextView.borderColor = kAppThemeLoginTextfieldBorderColor;
        _registPassTextView.borderWidth = 2;
        [_whiteBg addSubview:_registPassTextView];
    }

    if (!_registPassCConfirmTextView) {
        _registPassCConfirmTextView = [[CMSimpleTextView alloc] initWithIcon:[UIImage imageNamed:@"pass_ico"] andWithPlaceholder:@"确认密码" andWithInputType:Email];
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
        [_whiteBg addSubview:_registBtn];
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
