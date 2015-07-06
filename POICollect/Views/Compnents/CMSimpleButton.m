//
//  CMSimpleButton.m
//  POICollect
//  自定义按钮
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMSimpleButton.h"
#import "UIImage+Expanded.h"

#define kDefaultNormalBackgroundColor kAppThemePrimaryColor
//#define kDefaultHighlightBackgroundColor
#define kDefaultDisableBackgroundColor [UIColor grayColor]
#define kDefaultNormalForegroundColor kAppThemeSecondaryColor
//#define kDefaultHighlightForegroundColor
#define kDefaultDisableForegroundColor [UIColor darkTextColor]
#define kDefaultNormalBorderColor [UIColor whiteColor]
//#define kDefaultHighlightBorderColor
//#define kDefaultDisableBorderColor

static const CGFloat sDefaultCornerRadius = 4.f;
static const CGFloat sDefaultBorderWidth = 1.f;

@implementation CMSimpleButton

#pragma mark - 初始化方法

- (id)initSimpleButtonWithTitle:(NSString*)title
{
    return [self initSimpleButtonWithFrame:CGRectZero WithTitle:title andBackgroundColor:kDefaultNormalBackgroundColor andForegroundColor:kDefaultNormalForegroundColor andBorderColor:kDefaultNormalBorderColor andCornerRadius:sDefaultCornerRadius andBorderWidth:sDefaultBorderWidth];
}

- (id)initSimpleButtonWithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor
{
    return [self initSimpleButtonWithFrame:CGRectZero WithTitle:title andBackgroundColor:backgroundColor andForegroundColor:foregroundColor andBorderColor:borderColor andCornerRadius:sDefaultCornerRadius andBorderWidth:sDefaultBorderWidth];
}

- (id)initSimpleButtonWithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor andCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth
{
    return [self initSimpleButtonWithFrame:CGRectZero WithTitle:title andBackgroundColor:backgroundColor andForegroundColor:foregroundColor andBorderColor:borderColor andCornerRadius:radius andBorderWidth:borderWidth];
}

- (id)initSimpleButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor andCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.text = title;
        _normalBorderColor = backgroundColor;
        _normalForegroundColor = foregroundColor;
        _normalBorderColor = borderColor;
        _cornerRadius = radius;
        _borderWidth = borderWidth;

        [self configView];
    }
    return self;
}

#pragma mark 私有的实例方法

- (void)configView
{
    self.showsTouchWhenHighlighted = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    self.titleLabel.shadowOffset = CGSizeZero;
    self.layer.masksToBounds = YES;

    _normalBackgroundColor = _normalBackgroundColor ? _normalBackgroundColor : kDefaultNormalBackgroundColor;
    _highlightBackgroundColor = _highlightBackgroundColor ? _highlightBackgroundColor : [self darkenedColorFromColor:_normalBackgroundColor];
    _disableBackgroundColor = _disableBackgroundColor ? _disableBackgroundColor : kDefaultDisableBackgroundColor;

    [self setBackgroundImage:[self imageWithColor:_normalBackgroundColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self imageWithColor:_highlightBackgroundColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self imageWithColor:_disableBackgroundColor] forState:UIControlStateDisabled];

    _normalForegroundColor = _normalForegroundColor ? _normalForegroundColor : kDefaultNormalForegroundColor;
    _highlightForegroundColor = _highlightForegroundColor ? _highlightForegroundColor : [self lightenedColorFromColor:_normalForegroundColor];
    _disableForegroundColor = _disableForegroundColor ? _disableForegroundColor : kDefaultDisableForegroundColor;
    [self setTitleColor:_normalForegroundColor forState:UIControlStateNormal];
    [self setTitleColor:_highlightForegroundColor forState:UIControlStateHighlighted];
    [self setTitleColor:_disableForegroundColor forState:UIControlStateDisabled];

    _normalBorderColor = _normalBorderColor ? _normalBorderColor : kDefaultNormalBorderColor;
    _highlightBorderColor = _highlightBorderColor ? _highlightBorderColor : _normalBorderColor;
    _disableBorderColor = _disableBorderColor ? _disableBorderColor : kDefaultDisableBackgroundColor;
    self.layer.borderColor = _normalBorderColor.CGColor;

    _cornerRadius = _cornerRadius ? _cornerRadius : sDefaultCornerRadius;
    _borderWidth = _borderWidth ? _borderWidth : sDefaultBorderWidth;
    self.layer.borderWidth = _borderWidth;
    self.layer.cornerRadius = _cornerRadius;
}

#pragma mark - 继承

- (instancetype)init
{
    self = [super init];
    if (self) {
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

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    //    self.backgroundColor = highlighted ? [UIColor blackColor] : _normalBackgroundColor;
    self.layer.borderColor = highlighted ? _highlightBorderColor.CGColor : _normalBorderColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    //    self.backgroundColor = enabled ? _normalBackgroundColor : _disableBackgroundColor;
    self.layer.borderColor = enabled ? _normalBorderColor.CGColor : _disableBorderColor.CGColor;
    [self setNeedsDisplay];
}

#pragma mark - Setter

- (void)setNormalBackgroundColor:(UIColor*)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self configView];
}

- (void)setHighlightBackgroundColor:(UIColor*)highlightBackgroundColor
{
    _highlightBackgroundColor = highlightBackgroundColor;
    [self configView];
}

- (void)setDisableBackgroundColor:(UIColor*)disableBackgroundColor
{
    _disableBackgroundColor = disableBackgroundColor;
    [self configView];
}

- (void)setNormalForegroundColor:(UIColor*)normalForegroundColor
{
    _normalForegroundColor = normalForegroundColor;
    [self configView];
}

- (void)setHighlightForegroundColor:(UIColor*)highlightForegroundColor
{
    _highlightForegroundColor = highlightForegroundColor;
    [self configView];
}

- (void)setDisableForegroundColor:(UIColor*)disableForegroundColor
{
    _disableForegroundColor = disableForegroundColor;
    [self configView];
}

- (void)setNormalBorderColor:(UIColor*)normalBorderColor
{
    _normalBorderColor = normalBorderColor;
    [self configView];
}

- (void)setHighlightBorderColor:(UIColor*)highlightBorderColor
{
    _highlightBorderColor = highlightBorderColor;
    [self configView];
}

- (void)setDisableBorderColor:(UIColor*)disableBorderColor
{
    _disableBorderColor = disableBorderColor;
    [self configView];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self configView];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self configView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 工具方法

- (UIColor*)darkenedColorFromColor:(UIColor*)color
{
    CGFloat h, s, b, a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b * 0.85f alpha:a];
}

- (UIColor*)lightenedColorFromColor:(UIColor*)color
{
    CGFloat h, s, b, a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b * 1.15f alpha:a];
}

- (UIImage*)imageWithColor:(UIColor*)color
{
    return [UIImage imageWithColor:color andWithFrame:CGRectMake(0, 0, 1, 1)];
}

- (UIImage*)imageWithColor:(UIColor*)color andWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, frame);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
