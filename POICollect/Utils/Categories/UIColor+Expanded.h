//
//  UIColor+Expanded.h
//  POICollect
//  UIColor的扩展类
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#define SUPPORTS_UNDOCUMENTED_API 0

@interface UIColor (Expanded)

#pragma mark - 属性

/**
 *  颜色空间类型
 */
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;

/**
 *  颜色是否提供RGB成分
 */
@property (nonatomic, readonly) BOOL canProvideRGBComponents;

/**
 *  红色的值
 */
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES

/**
 *  绿色的值
 */
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES

/**
 *  蓝色的值
 */
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES

/**
 *  白色的值，只有在kCGColorSpaceModelMonochrome类型的时候可用
 */
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome

/**
 *  透明度
 */
@property (nonatomic, readonly) CGFloat alpha;

/**
 *  颜色的16进制数
 */
@property (nonatomic, readonly) UInt32 rgbHex;

#pragma mark - 扩展的实例方法

/**
 *  得到颜色的颜色空间
 *
 *  @return 颜色空间的字符串
 */
- (NSString*)colorSpaceString;

/**
 *  得到颜色的R、G、B、A的数组
 *
 *  @return 数组
 */
- (NSArray*)arrayFromRGBAComponents;

/**
 *  得到颜色的R、G、B、A的值
 *
 *  @param red   red的值
 *  @param green green的值
 *  @param blue  blue的值
 *  @param alpha 透明度
 *
 *  @return 返回是不是有四个值
 */
- (BOOL)red:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue alpha:(CGFloat*)alpha;

/**
 *  得到颜色的高亮颜色
 *
 *  @return 返回当前颜色的高亮的颜色
 */
- (UIColor*)colorByLuminanceMapping;

/**
 *  颜色的倍增
 *
 *  @param red   红色倍增
 *  @param green 绿色倍增
 *  @param blue  蓝色倍增
 *  @param alpha 透明度倍增
 *
 *  @return 返回修改后的颜色
 */
- (UIColor*)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  颜色各个色值添加
 *
 *  @param red   红色添加
 *  @param green 绿色添加
 *  @param blue  蓝色添加
 *  @param alpha 透明度添加
 *
 *  @return 返回修改后的颜色
 */
- (UIColor*)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  增亮
 *
 *  @param red   red description
 *  @param green green description
 *  @param blue  blue description
 *  @param alpha alpha description
 *
 *  @return return value description
 */
- (UIColor*)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  变暗
 *
 *  @param red   red description
 *  @param green green description
 *  @param blue  blue description
 *  @param alpha alpha description
 *
 *  @return return value description
 */
- (UIColor*)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor*)colorByMultiplyingBy:(CGFloat)f;
- (UIColor*)colorByAdding:(CGFloat)f;
- (UIColor*)colorByLighteningTo:(CGFloat)f;
- (UIColor*)colorByDarkeningTo:(CGFloat)f;

- (UIColor*)colorByMultiplyingByColor:(UIColor*)color;
- (UIColor*)colorByAddingColor:(UIColor*)color;
- (UIColor*)colorByLighteningToColor:(UIColor*)color;
- (UIColor*)colorByDarkeningToColor:(UIColor*)color;

/**
 *  颜色的字符串
 *
 *  @return 字符串
 */
- (NSString*)stringFromColor;

/**
 *  颜色的十六进制字符串
 *
 *  @return 十六进制
 */
- (NSString*)hexStringFromColor;

/**
 *  得到一个随机的颜色
 *
 *  @return 返回的随机的颜色
 */
+ (UIColor*)randomColor;

/**
 *  通过String生成颜色
 *
 *  @param stringToConvert "{0.0, 0.0, 0.0, 0.4}" 或者 "{0.0, 0.6}"
 *
 *  @return return value description
 */
+ (UIColor*)colorWithString:(NSString*)stringToConvert;

/**
 *  通过16进制生成颜色
 *
 *  @param hex 十六进制整数
 *
 *  @return 返回颜色
 */
+ (UIColor*)colorWithRGBHex:(UInt32)hex;

/**
 *  通过16进制字符串生成颜色
 *
 *  @param stringToConvert 十六进制字符串
 *
 *  @return 返回颜色
 */
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;

/**
 *  通过16进制字符串和透明度生成颜色
 *
 *  @param stringToConvert 十六进制字符串
 *  @param alpha           透明度
 *
 *  @return 返回颜色
 */
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert andAlpha:(CGFloat)alpha;

/**
 *  Lookup a color using css 3/svg color name
 *
 *  @param cssColorName css 的名字
 *
 *  @return 返回的颜色
 */
+ (UIColor*)colorWithName:(NSString*)cssColorName;

@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface UIColor (Undocumented_Expanded)
- (NSString*)fetchStyleString;
- (UIColor*)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API
