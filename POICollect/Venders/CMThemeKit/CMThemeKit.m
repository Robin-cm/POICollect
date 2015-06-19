//
//  CMThemeKit.m
//  POICollect
//  主题颜色修改
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMThemeKit.h"

/**
 *  默认的导航条的文字的大小
 */
static CGFloat const kDefaultNavigationBarFontSize = 20;

/**
 *  默认的TabBar的文字大小
 */
static CGFloat const kDefaultTabBarFontSize = 14;

@implementation CMThemeKit

#pragma mark - Master Theme

/**
 *  设置主题的颜色，字体，状态栏
 *
 *  @param primaryColor   主要颜色
 *  @param secondaryColor 次要颜色
 *  @param fontName       字体的名称
 *  @param lightStatusBar 是不是白色的状态栏
 */
+ (void)setupThemeWithPrimaryColor:(UIColor*)primaryColor secondaryColor:(UIColor*)secondaryColor fontName:(NSString*)fontName lightStatusBar:(BOOL)lightStatusBar
{
    if (lightStatusBar) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }

    [self customizeNavigationBarColor:primaryColor textColor:secondaryColor fontName:fontName fontSize:kDefaultNavigationBarFontSize buttonColor:secondaryColor];
    [self customizeNavigationBarButtonColor:secondaryColor];
    [self customizeTabBarColor:primaryColor textColor:secondaryColor fontName:fontName fontSize:kDefaultTabBarFontSize];
    [self customizeSwitchOnColor:primaryColor];
    [self customizeSearchBarColor:primaryColor buttonTintColor:secondaryColor];
    [self customizeActivityIndicatorColor:primaryColor];
    [self customizeButtonColor:primaryColor];
    [self customizeSegmentedControlWithMainColor:primaryColor secondaryColor:secondaryColor];
    [self customizeSliderColor:primaryColor];
    [self customizePageControlCurrentPageColor:primaryColor];
    [self customizeToolbarTintColor:secondaryColor barTintColor:primaryColor];
    [self customizeLabelColor:primaryColor fontName:fontName fontSize:kDefaultNavigationBarFontSize];
    [self customizeBarButtonItemColor:secondaryColor fontName:fontName fontSize:kDefaultNavigationBarFontSize];
}

#pragma mark - UINavigationBar

/**
 *  自定义导航栏的颜色、文字的颜色、按钮的颜色
 *
 *  @param barColor    导航条的颜色
 *  @param textColor   文字的颜色
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarColor:(UIColor*)barColor textColor:(UIColor*)textColor buttonColor:(UIColor*)buttonColor
{
    [UINavigationBar appearance].barTintColor = barColor;
    [UINavigationBar appearance].tintColor = buttonColor;
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName : textColor };
}

/**
 *  自定义导航栏
 *
 *  @param barColor    导航条的背景颜色
 *  @param textColor   文字的颜色
 *  @param fontName    文本的字体名称
 *  @param fontSize    文字的大小
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarColor:(UIColor*)barColor textColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize buttonColor:(UIColor*)buttonColor
{
    [UINavigationBar appearance].barTintColor = barColor;
    [UINavigationBar appearance].tintColor = buttonColor;
    UIFont* font = [UIFont fontWithName:fontName size:fontSize];
    if (font) {
        [UINavigationBar appearance].titleTextAttributes = @{
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font
        };
    }
}

#pragma mark - UIBarButtonItem

/**
 *  自定义导航条的按钮的颜色
 *
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarButtonColor:(UIColor*)buttonColor
{
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:buttonColor forState:UIControlStateNormal];
}

#pragma mark - UITabBar

/**
 *  自定义tabbar的颜色
 *
 *  @param barColor  tabbar的背景色
 *  @param textColor 文本的颜色
 */
+ (void)customizeTabBarColor:(UIColor*)barColor textColor:(UIColor*)textColor
{
    [UITabBar appearance].barTintColor = barColor;
    [UITabBar appearance].tintColor = textColor;
}

/**
 *  自定义tabbar的颜色
 *
 *  @param barColor  tabbar的背景色
 *  @param textColor 文本的颜色
 *  @param fontName  文字的字体名称
 *  @param fontSize  文字的颜色
 */
+ (void)customizeTabBarColor:(UIColor*)barColor textColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
{
    [[UITabBar appearance] setBarTintColor:barColor];
    [[UITabBar appearance] setTintColor:textColor];

    UIFont* font = [UIFont fontWithName:fontName size:fontSize];

    if (font) {
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : font } forState:UIControlStateNormal];
    }
}

#pragma mark - UIButton

/**
 *  自定义按钮
 *
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeButtonColor:(UIColor*)buttonColor
{
    [[UIButton appearance] setTitleColor:buttonColor forState:UIControlStateNormal];
}

#pragma mark - UISwitch

/**
 *  自定义开关按钮
 *
 *  @param switchOnColor 颜色
 */
+ (void)customizeSwitchOnColor:(UIColor*)switchOnColor
{
    [[UISwitch appearance] setOnTintColor:switchOnColor];
}

#pragma mark - UISearchBar

/**
 *  自定义搜索条
 *
 *  @param barColor        背景颜色
 *  @param buttonTintColor 按钮颜色
 */
+ (void)customizeSearchBarColor:(UIColor*)barColor buttonTintColor:(UIColor*)buttonTintColor
{
    [[UISearchBar appearance] setBarTintColor:barColor];
    [[UISearchBar appearance] setTintColor:barColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : buttonTintColor } forState:UIControlStateNormal];
}

#pragma mark - UIActivityIndicator

/**
 *  自定义菊花图标
 *
 *  @param color 颜色
 */
+ (void)customizeActivityIndicatorColor:(UIColor*)color
{
    [[UIActivityIndicatorView appearance] setColor:color];
}

#pragma mark - UISegmentedControl

/**
 *  自定义分段控件
 *
 *  @param mainColor      主要颜色
 *  @param secondaryColor 次要颜色
 */
+ (void)customizeSegmentedControlWithMainColor:(UIColor*)mainColor secondaryColor:(UIColor*)secondaryColor
{
    [[UISegmentedControl appearance] setTintColor:mainColor];
}

#pragma mark - UISlider

/**
 *  自定义Slider
 *
 *  @param sliderColor 颜色
 */
+ (void)customizeSliderColor:(UIColor*)sliderColor
{
    [[UISlider appearance] setMinimumTrackTintColor:sliderColor];
}

#pragma mark - UIToolbar

/**
 *  自定义工具条
 *
 *  @param tintColor    颜色
 *  @param barTintColor 背景色
 */
+ (void)customizeToolbarTintColor:(UIColor*)tintColor barTintColor:(UIColor*)barTintColor
{
    [self customizeToolbarTintColor:tintColor];
    [self customizeToolbarBarTintColor:barTintColor];
}

/**
 *  自定义工具条
 *
 *  @param tintColor 颜色
 */
+ (void)customizeToolbarTintColor:(UIColor*)tintColor
{
    [[UIToolbar appearance] setTintColor:tintColor];
}

/**
 *  自定义工具条
 *
 *  @param barTintColor bar颜色
 */
+ (void)customizeToolbarBarTintColor:(UIColor*)barTintColor
{
    [[UIToolbar appearance] setBarTintColor:barTintColor];
}

#pragma mark - UIPageControl

/**
 *  自定义pagecontrol
 *
 *  @param mainColor 颜色
 */
+ (void)customizePageControlCurrentPageColor:(UIColor*)mainColor
{
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:mainColor];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - UILabel

/**
 *  自定义Label
 *
 *  @param textColor 文字颜色
 *  @param fontName  文字字体名称
 *  @param fontSize  文字大小
 */
+ (void)customizeLabelColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
{
    [[UILabel appearance] setTextColor:textColor];

    UIFont* font = [UIFont fontWithName:fontName size:fontSize];

    if (font) {
        [[UILabel appearance] setFont:font];
    }
}

#pragma mark - UITableView

/**
 *  自定义TableView颜色
 *
 *  @param mainColor      主要颜色
 *  @param secondaryColor 次要颜色
 */
+ (void)customizeTableViewColor:(UIColor*)mainColor secondaryColor:(UIColor*)secondaryColor
{
    [[UITableView appearance] setTintColor:mainColor];
    [[UITableView appearance] setSeparatorColor:secondaryColor];
}

#pragma mark - UIBarButtonItem

/**
 *  自定义barbuttonItem
 *
 *  @param mainColor 主要颜色
 *  @param fontName  文字字体名称
 *  @param fontSize  文字大小
 */
+ (void)customizeBarButtonItemColor:(UIColor*)mainColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
        NSForegroundColorAttributeName : mainColor
    } forState:UIControlStateNormal];
}

#pragma mark - Color 工具

+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    CGFloat red = r / 255.0f;
    CGFloat green = g / 255.0f;
    CGFloat blue = b / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString* cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor grayColor];
    }

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }

    if ([cString length] != 6) {
        return [UIColor grayColor];
    }

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];

    range.location = 2;
    NSString* gString = [cString substringWithRange:range];

    range.location = 4;
    NSString* bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [CMThemeKit colorWithR:(float)r G:(float)g B:(float)b];
}

@end
