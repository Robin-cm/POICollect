//
//  UIview+CMExpened.h
//  POICollect
//
//  Created by 敏梵 on 15/6/20.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface UIView (CMExpened)

- (UIView*)viewWithColor:(UIColor*)color;

- (void)borderWithColor:(UIColor*)borderColor andWidth:(CGFloat)borderWidth;

- (void)circleCornerWithRadius:(CGFloat)radius;

/**
 *  添加渐变的层
 *  @param  cgColorArray    颜色的数组，CGColor
 **/
- (void)addGradientLayerWithColors:(NSArray*)cgColorArray;

/**
 *  添加渐变的层
 *  @param  cgColorArray    颜色数组
 *  @param  floatNumArray
 *  @param  aPoint          起点坐标
 *  @param  endPoint        重点坐标
 **/
- (void)addGradientLayerWithColors:(NSArray*)cgColorArray locations:(NSArray*)floatNumArray startPoint:(CGPoint)aPoint endPoint:(CGPoint)endPoint;

/**
 *  在UIView添加横线
 *  @param  hasUp   是不是添加上面
 *  @param  hasDown 是不是添加下面
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown;

/**
 *  在UIView添加横线
 *  @param  hasUp   是不是添加上面
 *  @param  hasDown 是不是添加下面
 *  @param  color   线条的颜色
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor*)color;

/**
 *  在UIView添加横线
 *  @param  hasUp       是不是添加上面
 *  @param  hasDown     是不是添加下面
 *  @param  color       线条的颜色
 *  @param  leftSpace   线条距离左边的距离
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor*)color andLeftSpace:(CGFloat)leftSpace;

/**
 *  删除一个View通过tag
 *  @param  tag   标识
 **/
- (void)removeViewWithTag:(NSInteger)tag;

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY   横线的Y坐标
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY;

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY      横线的Y坐标
 *  @param  color       横线的颜色
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor*)color;

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY      横线的Y坐标
 *  @param  color       横线的颜色
 *  @param  leftSpace   横线距离左边的距离
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor*)color andLeftSpace:(CGFloat)leftSpace;

@end
