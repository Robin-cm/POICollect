//
//  CMThemeKit.h
//  POICollect
//  主题颜色修改
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

/*
 Loosely based on the list of methods and properties conforming to UIAppearance
 in iOS 7, by Mattt.
 https://gist.github.com/mattt/5135521
 
 This is by no means an exhaustive list, but the most common things I see in most apps.
 */

@interface CMThemeKit : NSObject

#pragma mark - Master Theme

/**
 *  设置主题的颜色，字体，状态栏
 *
 *  @param primaryColor   主要颜色
 *  @param secondaryColor 次要颜色
 *  @param fontName       字体的名称
 *  @param lightStatusBar 是不是白色的状态栏
 */
+ (void)setupThemeWithPrimaryColor:(UIColor*)primaryColor secondaryColor:(UIColor*)secondaryColor fontName:(NSString*)fontName lightStatusBar:(BOOL)lightStatusBar;

#pragma mark - UINavigationBar

/**
 *  自定义导航栏的颜色、文字的颜色、按钮的颜色
 *
 *  @param barColor    导航条的颜色
 *  @param textColor   文字的颜色
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarColor:(UIColor*)barColor textColor:(UIColor*)textColor buttonColor:(UIColor*)buttonColor;

/**
 *  自定义导航栏
 *
 *  @param barColor    导航条的背景颜色
 *  @param textColor   文字的颜色
 *  @param fontName    文本的字体名称
 *  @param fontSize    文字的大小
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarColor:(UIColor*)barColor textColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize buttonColor:(UIColor*)buttonColor;

#pragma mark - UIBarButtonItem

/**
 *  自定义导航条的按钮的颜色
 *
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeNavigationBarButtonColor:(UIColor*)buttonColor;

#pragma mark - UITabBar

/**
 *  自定义tabbar的颜色
 *
 *  @param barColor  tabbar的背景色
 *  @param textColor 文本的颜色
 */
+ (void)customizeTabBarColor:(UIColor*)barColor textColor:(UIColor*)textColor;

/**
 *  自定义tabbar的颜色
 *
 *  @param barColor  tabbar的背景色
 *  @param textColor 文本的颜色
 *  @param fontName  文字的字体名称
 *  @param fontSize  文字的颜色
 */
+ (void)customizeTabBarColor:(UIColor*)barColor textColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

#pragma mark - UIButton

/**
 *  自定义按钮
 *
 *  @param buttonColor 按钮的颜色
 */
+ (void)customizeButtonColor:(UIColor*)buttonColor;

#pragma mark - UISwitch

/**
 *  自定义开关按钮
 *
 *  @param switchOnColor 颜色
 */
+ (void)customizeSwitchOnColor:(UIColor*)switchOnColor;

#pragma mark - UISearchBar

/**
 *  自定义搜索条
 *
 *  @param barColor        背景颜色
 *  @param buttonTintColor 按钮颜色
 */
+ (void)customizeSearchBarColor:(UIColor*)barColor buttonTintColor:(UIColor*)buttonTintColor;

#pragma mark - UIActivityIndicator

/**
 *  自定义菊花图标
 *
 *  @param color 颜色
 */
+ (void)customizeActivityIndicatorColor:(UIColor*)color;

#pragma mark - UISegmentedControl

/**
 *  自定义分段控件
 *
 *  @param mainColor      主要颜色
 *  @param secondaryColor 次要颜色
 */
+ (void)customizeSegmentedControlWithMainColor:(UIColor*)mainColor secondaryColor:(UIColor*)secondaryColor;

#pragma mark - UISlider

/**
 *  自定义Slider
 *
 *  @param sliderColor 颜色
 */
+ (void)customizeSliderColor:(UIColor*)sliderColor;

#pragma mark - UIToolbar

/**
 *  自定义工具条
 *
 *  @param tintColor    颜色
 *  @param barTintColor 背景色
 */
+ (void)customizeToolbarTintColor:(UIColor*)tintColor barTintColor:(UIColor*)barTintColor;

/**
 *  自定义工具条
 *
 *  @param tintColor 颜色
 */
+ (void)customizeToolbarTintColor:(UIColor*)tintColor;

/**
 *  自定义工具条
 *
 *  @param barTintColor bar颜色
 */
+ (void)customizeToolbarBarTintColor:(UIColor*)barTintColor;

#pragma mark - UIPageControl

/**
 *  自定义pagecontrol
 *
 *  @param mainColor 颜色
 */
+ (void)customizePageControlCurrentPageColor:(UIColor*)mainColor;

#pragma mark - UILabel

/**
 *  自定义Label
 *
 *  @param textColor 文字颜色
 *  @param fontName  文字字体名称
 *  @param fontSize  文字大小
 */
+ (void)customizeLabelColor:(UIColor*)textColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

#pragma mark - UITableView

/**
 *  自定义TableView颜色
 *
 *  @param mainColor      主要颜色
 *  @param secondaryColor 次要颜色
 */
+ (void)customizeTableViewColor:(UIColor*)mainColor secondaryColor:(UIColor*)secondaryColor;

#pragma mark - UIBarButtonItem

/**
 *  自定义barbuttonItem
 *
 *  @param mainColor 主要颜色
 *  @param fontName  文字字体名称
 *  @param fontSize  文字大小
 */
+ (void)customizeBarButtonItemColor:(UIColor*)mainColor fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

#pragma mark - Color 工具

+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
+ (UIColor*)colorWithHexString:(NSString*)hex;

@end
