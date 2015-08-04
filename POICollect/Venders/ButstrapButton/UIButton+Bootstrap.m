//
//  UIButton+Bootstrap.m
//  POICollect
//
//  Created by 常敏 on 15/7/16.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UIButton+Bootstrap.h"

@implementation UIButton (Bootstrap)

#pragma mark - 继承父类

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - 实例方法

/**
 *  添加图标
 *
 *  @param icon   图标
 *  @param before 是否在标题之前
 */
- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before
{
    NSString* iconString = [NSString stringWithAwesomeIcon:icon];
    self.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize];
    NSString* title = [NSString stringWithFormat:@"%@", iconString];
    if (self.titleLabel.text) {
        if (before) {
            title = [title stringByAppendingFormat:@" %@", self.titleLabel.text];
        }
        else {
            title = [NSString stringWithFormat:@"%@ %@", self.titleLabel.text, title];
        }
    }
    [self setTitle:title forState:UIControlStateNormal];
}

/**
 *  bootstrap样式
 */
- (void)bootstrapStyle
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
}

/**
 *  默认样式
 */
- (void)defaultStyle
{
    [self defaultStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

/**
 *  primary样式
 */
- (void)primaryStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:66 / 255.0 green:139 / 255.0 blue:202 / 255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:53 / 255.0 green:126 / 255.0 blue:189 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51 / 255.0 green:119 / 255.0 blue:172 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

/**
 *  success样式
 */
- (void)successStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:92 / 255.0 green:184 / 255.0 blue:92 / 255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:76 / 255.0 green:174 / 255.0 blue:76 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:69 / 255.0 green:164 / 255.0 blue:84 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

/**
 *  info样式
 */
- (void)infoStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91 / 255.0 green:192 / 255.0 blue:222 / 255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70 / 255.0 green:184 / 255.0 blue:218 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57 / 255.0 green:180 / 255.0 blue:211 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

/**
 *  warning样式
 */
- (void)warningStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:173 / 255.0 blue:78 / 255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238 / 255.0 green:162 / 255.0 blue:54 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237 / 255.0 green:155 / 255.0 blue:67 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

/**
 *  danger样式
 */
- (void)dangerStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:83 / 255.0 blue:79 / 255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:212 / 255.0 green:63 / 255.0 blue:58 / 255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:210 / 255.0 green:48 / 255.0 blue:51 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
}

#pragma mark - 自定义私有方法

- (UIImage*)buttonImageFromColor:(UIColor*)color
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
