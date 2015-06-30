//
//  CMSimpleTextView.m
//  POICollect
//  登陆注册时的输入框
//  Created by 敏梵 on 15/6/21.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMSimpleTextView.h"

static const NSString* sDefaultPlaceHolder = @"请输入...";
static const CGFloat sDefaultBorderWidth = 1;
static const CGFloat sDefaultFoucsBorderWidth = 1;
static const CGFloat sDefaultCornerRadius = 4.f;

#define kDefaultFont [UIFont systemFontOfSize:15]

#define kDefaultBacgroudColor [UIColor whiteColor]
#define kDefaultBorderColor [UIColor lightGrayColor].CGColor
#define kDefaultFocusBorderColor kAppThemePrimaryColor.CGColor
#define kDefaultErrorBorderColor kAppThemeThirdColor

@interface CMSimpleTextView () <UITextFieldDelegate> {
    NSString* _error;

    BOOL _active;
}

@property (nonatomic, strong) UIButton* toolTip;

@property (nonatomic, strong) UIColor* textTempColor;

@end

@implementation CMSimpleTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 70);
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

#pragma mark - 初始化方法

- (id)initWithPlaceholder:(NSString*)placeholder
{
    return [self initWithPlaceholder:placeholder andWithInputType:EnglishOnly];
}

- (id)initWithInputType:(CMSimpleTextFieldType)inputType
{
    return [self initWithPlaceholder:nil andWithInputType:inputType];
}

- (id)initWithPlaceholder:(NSString*)placeholder andWithInputType:(CMSimpleTextFieldType)inputType
{
    return [self initWithIcon:nil andWithPlaceholder:placeholder andWithInputType:inputType];
}

- (id)initWithIcon:(UIImage*)icon andWithPlaceholder:(NSString*)placeholder andWithInputType:(CMSimpleTextFieldType)inputType
{
    self = [super init];
    if (self) {
        if (placeholder) {
            _placeHolder = placeholder;
        }
        _icon = icon;
        _cType = inputType;
        [self configView];
        [self configInputType];
    }
    return self;
}

#pragma mark - 继承

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + (_icon ? 35 : 10), bounds.origin.y, bounds.size.width - (_icon ? 35 : 10), bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + (_icon ? 35 : 10), bounds.origin.y, bounds.size.width - (_icon ? 35 : 10), bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + (_icon ? 35 : 10), bounds.origin.y, bounds.size.width - (_icon ? 35 : 10), bounds.size.height);
}

#pragma mark - Setter

- (void)setError
{
    self.layer.borderColor = _errorBorderColor.CGColor ? _errorBorderColor.CGColor : kDefaultErrorBorderColor.CGColor;
    self.layer.borderWidth = _foucsBorderWidth ? _foucsBorderWidth : sDefaultFoucsBorderWidth;
    if (!_toolTip) {
        _toolTip = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, self.frame.size.height)];
        //        _toolTip.titleLabel.textAlignment = NSTextAlignmentLeft;
        _toolTip.backgroundColor = _errorBorderColor ? _errorBorderColor : kDefaultErrorBorderColor;
        [_toolTip setBackgroundColor:_errorBorderColor ? _errorBorderColor : kDefaultErrorBorderColor];
        [_toolTip setTitle:@"?" forState:UIControlStateNormal];
        [_toolTip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    _toolTip.titleLabel.font = [UIFont fontWithName:JOTextFieldFont size:FONT_MEDIUM];
        _toolTip.titleLabel.font = _foucsFont ? _foucsFont : kDefaultFont;
        [_toolTip addTarget:self action:@selector(extendHelp) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = _toolTip;
    }
    self.rightView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         weakSelf.rightView.alpha = 1.0;
                     }];
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
}

- (void)setErrorBorderColor:(UIColor*)errorBorderColor
{
    _errorBorderColor = errorBorderColor;
}

- (void)setBorderColor:(UIColor*)borderColor
{
    _borderColor = borderColor;
    [self updateView];
}

- (void)setFoucsBorderColor:(UIColor*)foucsBorderColor
{
    _foucsBorderColor = foucsBorderColor;
}

- (void)setFoucsFont:(UIFont*)foucsFont
{
    _foucsFont = foucsFont;
}

- (void)setNormalFont:(UIFont*)normalFont
{
    _normalFont = normalFont;
    [self updateView];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateView];
}

- (void)setPlaceHolder:(NSString*)placeHolder
{
    _placeHolder = placeHolder;
    [self configInputType];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateView];
}

- (void)setFoucsBorderWidth:(CGFloat)foucsBorderWidth
{
    _foucsBorderWidth = foucsBorderWidth;
}

#pragma mark - 私有方法

- (void)configView
{
    self.layer.cornerRadius = sDefaultCornerRadius;
    self.layer.borderColor = kDefaultBorderColor;
    self.layer.borderWidth = sDefaultBorderWidth;
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.font = [UIFont systemFontOfSize:15];

    if (_icon) {
        UIView* views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        views.backgroundColor = [UIColor clearColor];
        UIImageView* iconView = [[UIImageView alloc] initWithImage:_icon];
        iconView.frame = CGRectMake(10, 0, 20, 20);
        [views addSubview:iconView];
        self.leftView = views;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)updateView
{
    self.layer.cornerRadius = _cornerRadius ? _cornerRadius : sDefaultCornerRadius;
    self.layer.borderColor = _borderColor ? _borderColor.CGColor : kDefaultBorderColor;
    self.layer.borderWidth = _borderWidth ? _borderWidth : sDefaultBorderWidth;
    //    self.font = _normalFont ? _normalFont : [UIFont systemFontOfSize:15];
    self.backgroundColor = [UIColor whiteColor];
    [self setNeedsDisplay];
}

- (void)configInputType
{
    switch (_cType) {
    case Email:
        self.placeholder = _placeHolder ? _placeHolder : @"请输入邮箱...";
        self.keyboardType = UIKeyboardTypeEmailAddress;
        break;
    case Number:
        self.placeholder = _placeHolder ? _placeHolder : @"请输入数字...";
        self.keyboardType = UIKeyboardTypeNumberPad;
        break;
    case Password:
        self.placeholder = _placeHolder ? _placeHolder : @"请输入密码...";
        self.secureTextEntry = YES;
        break;
    case EnglishOnly:
        self.placeholder = _placeHolder ? _placeHolder : @"请输入...";
        self.keyboardType = UIKeyboardTypeURL;
        break;
    default:
        break;
    }
}

- (void)validate
{
    _error = @"";
    switch (_cType) {
    case Email:
        _error = ([self validateEmail:self.text] && ![self.text isEqualToString:@""]) ? @"" : @"邮箱格式不正确";
        break;
    case Number:
        _error = (![self.text isEqualToString:@""]) ? @"" : @"只能为数字";
        break;
    case Password:
        _error = self.text.length < 6 ? @"最少为6位" : @"";
        break;
    case EnglishOnly:
        _error = (![self.text isEqualToString:@""]) ? @"" : @"不能有汉字";
        break;
    }
    if (![_error isEqualToString:@""]) {
        [self setError];
    }
    //    return err;
}

- (BOOL)validateEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)extendHelp
{
    __weak typeof(self) weakSelf = self;
    if (_active) {
        _active = NO;

        [_toolTip setTitle:@"?" forState:UIControlStateNormal];

        if (IOS_SYSTEM_VERSION_8_OR_ABOVE) {
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:5.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 weakSelf.textColor = [weakSelf.textColor colorWithAlphaComponent:1.0];
                                 weakSelf.rightView.frame = CGRectMake(CGRectGetWidth(weakSelf.frame) - 30, 0, 30, CGRectGetHeight(weakSelf.frame));
                             }
                             completion:nil];
        }
        else {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 weakSelf.textColor = [weakSelf.textColor colorWithAlphaComponent:1.0];
                                 weakSelf.rightView.frame = CGRectMake(CGRectGetWidth(weakSelf.frame) - 30, 0, 30, CGRectGetHeight(weakSelf.frame));
                             }
                             completion:nil];
        }
    }
    else {
        _active = true;
        [_toolTip setTitle:_error forState:UIControlStateNormal];

        if (IOS_SYSTEM_VERSION_8_OR_ABOVE) {
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:5.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 weakSelf.textColor = [weakSelf.textColor colorWithAlphaComponent:0.0];
                                 weakSelf.rightView.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.frame), CGRectGetHeight(weakSelf.frame));
                             }
                             completion:nil];
        }
        else {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 weakSelf.textColor = [weakSelf.textColor colorWithAlphaComponent:0.0];
                                 weakSelf.rightView.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.frame), CGRectGetHeight(weakSelf.frame));
                             }
                             completion:nil];
        }
    }
}

#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    self.rightViewMode = UITextFieldViewModeNever;
    textField.layer.borderColor = _foucsBorderColor ? _foucsBorderColor.CGColor : kDefaultFocusBorderColor;
    textField.layer.borderWidth = _foucsBorderWidth ? _foucsBorderWidth : sDefaultFoucsBorderWidth;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    textField.layer.borderColor = _borderColor ? _borderColor.CGColor : kDefaultBorderColor;
    textField.layer.borderWidth = _borderWidth ? _borderWidth : sDefaultBorderWidth;
    [self validate];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //    CALayer* innerShadowOwnerLayer = [[CALayer alloc] init];
    //    innerShadowOwnerLayer.frame = CGRectMake(0, rect.size.height + 2, rect.size.width, 2);
    //    innerShadowOwnerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    //    innerShadowOwnerLayer.shadowColor = [UIColor blackColor].CGColor;
    //    innerShadowOwnerLayer.shadowOffset = CGSizeMake(0, 0);
    //    innerShadowOwnerLayer.shadowRadius = 10.0;
    //    innerShadowOwnerLayer.shadowOpacity = 0.7;
    //    [self.layer addSublayer:innerShadowOwnerLayer];
}*/

@end
