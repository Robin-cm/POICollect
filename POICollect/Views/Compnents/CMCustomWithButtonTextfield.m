//
//  CMCustomWithButtonTextfield.m
//  POICollect
//  带有按钮的输入框
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomWithButtonTextfield.h"

#define kDefaultFont [UIFont systemFontOfSize:15]

#define kDefaultBorderColor [UIColor clearColor]
#define kDefaultNormalBgColor [UIColor colorWithHexString:@"0x97C6E4"]
#define kDefaultNormalForeColor [UIColor colorWithHexString:@"0xffffff"]

static const CGFloat sDefaultCornerRadius = 4.0;
//static const CGFloat sDefaultBorderWidth = 1.0;

static const CGFloat sDefaultPadding = 10;

@interface CMCustomWithButtonTextfield () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton* rightBtn;

@end

@implementation CMCustomWithButtonTextfield

#pragma mark - 初始化方法

- (id)initButtonTextfieldWithPlaceholder:(NSString*)palceHolder
{
    return [self initButtonTextfieldWithPlaceholder:palceHolder andWithButtonImage:nil andWithSelectedButtonImage:nil];
}

- (id)initButtonTextfieldWithPlaceholder:(NSString*)palceHolder andWithButtonImage:(UIImage*)btnImg andWithSelectedButtonImage:(UIImage*)selectedBtnImg
{
    self = [super init];
    if (self) {
        self.placeholder = palceHolder;
        if (btnImg) {
            _rightBtnImage = btnImg;
        }
        if (selectedBtnImg) {
            _rightBtnSelectedImage = selectedBtnImg;
        }

        [self configView];
        [self updateView];
    }
    return self;
}

#pragma mark - Setter

#pragma mark -

//- (void)layoutSubviews
//{
//    if (_rightBtn) {
//        _rightBtn.frame = CGRectMake(0, 5, 30, self.bounds.size.height - 10);
//    }
//}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + sDefaultPadding, bounds.origin.y, bounds.size.width - sDefaultPadding, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + sDefaultPadding, bounds.origin.y, bounds.size.width - sDefaultPadding, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + sDefaultPadding, bounds.origin.y, bounds.size.width - sDefaultPadding, bounds.size.height);
}

#pragma mark - 自定义方法

- (void)configView
{
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.delegate = self;

    //    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    //    rightView.backgroundColor = [UIColor redColor];
    //    self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name_ico"]];
    //    self.leftViewMode = UITextFieldViewModeAlways;
    //    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)updateView
{
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.layer.cornerRadius = _cornerRadius ? _cornerRadius : sDefaultCornerRadius;
    //    self.layer.borderColor = _borderColor ? _borderColor.CGColor : kDefaultBorderColor.CGColor;
    //    self.layer.borderWidth = _borderWidth ? _borderWidth : sDefaultBorderWidth;
    self.font = _textFont ? _textFont : [UIFont systemFontOfSize:15];
    //    self.backgroundColor = _normalBackgroundColor ?: kDefaultNormalBgColor;
    self.backgroundColor = [UIColor lightGrayColor];
    _normalForegroundColor = _normalForegroundColor ?: kDefaultNormalForeColor;

    [self setTextColor:_normalForegroundColor];
    [self setTintColor:_normalForegroundColor];

    _rightBtnSelectedImage = _rightBtnSelectedImage ?: _rightBtnImage;

    if (_rightBtnImage && _rightBtnSelectedImage) {
        if (!_rightBtn) {
            _rightBtn = [[UIButton alloc] init];
            _rightBtn.frame = CGRectMake(0, 5, 30, 25);
            [_rightBtn setBackgroundImage:_rightBtnImage forState:UIControlStateNormal];
            //            _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 5, 15, 15);
            [_rightBtn setBackgroundImage:_rightBtnSelectedImage forState:UIControlStateHighlighted];
            [_rightBtn addTarget:self action:@selector(rightBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
            self.rightView = _rightBtn;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
    }

    [self setNeedsDisplay];
}

#pragma mark - 事件

- (void)rightBtnTaped:(id)sender
{
    NSLog(@"点击了按钮了！！！！！");
}

#pragma mark - UITextFieldDelegate

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
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
