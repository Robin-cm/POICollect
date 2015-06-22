//
//  CMSimpleButton.h
//  POICollect
//  自定义按钮
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface CMSimpleButton : UIButton

#pragma mark - 属性

@property (nonatomic, copy) UIColor* normalBackgroundColor;

@property (nonatomic, copy) UIColor* highlightBackgroundColor;

@property (nonatomic, copy) UIColor* disableBackgroundColor;

@property (nonatomic, copy) UIColor* normalForegroundColor;

@property (nonatomic, copy) UIColor* highlightForegroundColor;

@property (nonatomic, copy) UIColor* disableForegroundColor;

@property (nonatomic, copy) UIColor* normalBorderColor;

@property (nonatomic, copy) UIColor* highlightBorderColor;

@property (nonatomic, copy) UIColor* disableBorderColor;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;

#pragma mark - 初始化方法

- (id)initSimpleButtonWithTitle:(NSString*)title;

- (id)initSimpleButtonWithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor;

- (id)initSimpleButtonWithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor andCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth;

- (id)initSimpleButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor andBorderColor:(UIColor*)borderColor andCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth;

#pragma mark - 共有的实例方法

@end
