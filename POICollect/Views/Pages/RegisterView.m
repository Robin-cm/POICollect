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

static const CGFloat padding = 20;

@interface RegisterView () {
    UIView* _firstLine;

    UIView* _secendLine;

    UIView* _thirdLine;
}

@property (nonatomic, strong) CMSimpleTextView* registNameTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassTextView;

@property (nonatomic, strong) CMSimpleTextView* registPassCConfirmTextView;

@property (nonatomic, strong) UILabel* registNameLabel;

@property (nonatomic, strong) UILabel* registPassLabel;

@property (nonatomic, strong) UILabel* registPassConfirmLabel;

@property (nonatomic, strong) CMSimpleButton* registBtn;

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
    if (_registNameLabel) {
        [_registNameLabel makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.top).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(_registNameTextView.left).offset(-padding);
            make.height.equalTo(@35);
            make.width.equalTo(@80);
        }];
    }

    if (_registNameTextView) {
        [_registNameTextView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.top).offset(padding);
            make.left.equalTo(_registNameLabel.right).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_firstLine) {
        [_firstLine makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(_registNameLabel.bottom).offset(padding);
        }];
    }

    if (_registPassLabel) {
        [_registPassLabel makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(_registPassTextView.left).offset(-padding);
            make.height.equalTo(@35);
            make.width.equalTo(@80);
        }];
    }

    if (_registPassTextView) {
        [_registPassTextView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_firstLine.bottom).offset(padding);
            make.left.equalTo(_registPassLabel.right).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_secendLine) {
        [_secendLine makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(_registPassLabel.bottom).offset(padding);
        }];
    }

    if (_registPassConfirmLabel) {
        [_registPassConfirmLabel makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_secendLine.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(_registPassCConfirmTextView.left).offset(-padding);
            make.height.equalTo(@35);
            make.width.equalTo(@80);
        }];
    }

    if (_registPassCConfirmTextView) {
        [_registPassCConfirmTextView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_secendLine.bottom).offset(padding);
            make.left.equalTo(_registPassConfirmLabel.right).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@35);
        }];
    }

    if (_thirdLine) {
        [_thirdLine makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(_registPassCConfirmTextView.bottom).offset(padding);
        }];
    }

    if (_registBtn) {
        [_registBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.left).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.top.equalTo(_thirdLine.bottom).offset(padding);
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
    if (!_thirdLine) {
        _thirdLine = [[UIView alloc] init];
        _thirdLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_thirdLine];
    }

    if (!_registNameLabel) {
        _registNameLabel = [[UILabel alloc] init];
        _registNameLabel.textColor = [UIColor lightGrayColor];
        _registNameLabel.text = @"用户名";
        _registNameLabel.textAlignment = NSTextAlignmentJustified;
        [self addSubview:_registNameLabel];
    }
    if (!_registNameTextView) {
        _registNameTextView = [[CMSimpleTextView alloc] initWithPlaceholder:@"用户名..."];
        [self addSubview:_registNameTextView];
    }
    if (!_registPassLabel) {
        _registPassLabel = [[UILabel alloc] init];
        _registPassLabel.textAlignment = NSTextAlignmentJustified;
        _registPassLabel.textColor = [UIColor lightGrayColor];
        _registPassLabel.text = @"密    码";
        [self addSubview:_registPassLabel];
    }
    if (!_registPassTextView) {
        _registPassTextView = [[CMSimpleTextView alloc] initWithPlaceholder:@"密码..."];
        [self addSubview:_registPassTextView];
    }
    if (!_registPassConfirmLabel) {
        _registPassConfirmLabel = [[UILabel alloc] init];
        _registPassConfirmLabel.textAlignment = NSTextAlignmentJustified;
        _registPassConfirmLabel.textColor = [UIColor lightGrayColor];
        _registPassConfirmLabel.text = @"确认密码";
        [self addSubview:_registPassConfirmLabel];
    }
    if (!_registPassCConfirmTextView) {
        _registPassCConfirmTextView = [[CMSimpleTextView alloc] initWithPlaceholder:@"确认密码..."];
        [self addSubview:_registPassCConfirmTextView];
    }

    if (!_registBtn) {
        _registBtn = [[CMSimpleButton alloc] initSimpleButtonWithTitle:@"注册"];
        [self addSubview:_registBtn];
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
