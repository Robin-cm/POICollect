//
//  UIview+CMExpened.m
//  POICollect
//  视图的扩展类
//  Created by 敏梵 on 15/6/20.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UIView+CMExpened.h"

static const int kTagLineView = 1007;

@implementation UIView (CMExpened)

- (UIView*)viewWithColor:(UIColor*)color
{
    self.backgroundColor = color;
    return self;
}

- (void)borderWithColor:(UIColor*)borderColor andWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)circleCornerWithRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

/**
 *  添加渐变的层
 *  @param  cgColorArray    颜色的数组，CGColor
 **/
- (void)addGradientLayerWithColors:(NSArray*)cgColorArray
{
    [self addGradientLayerWithColors:cgColorArray locations:nil startPoint:CGPointMake(0.0, 0.5) endPoint:CGPointMake(1.0, 0.5)];
}

/**
 *  添加渐变的层
 *  @param  cgColorArray    颜色数组
 *  @param  floatNumArray
 *  @param  aPoint          起点坐标
 *  @param  endPoint        重点坐标
 **/
- (void)addGradientLayerWithColors:(NSArray*)cgColorArray locations:(NSArray*)floatNumArray startPoint:(CGPoint)aPoint endPoint:(CGPoint)endPoint
{
    CAGradientLayer* layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    if (cgColorArray && [cgColorArray count] > 0) {
        layer.colors = cgColorArray;
    }
    else {
        return;
    }
    if (floatNumArray && [floatNumArray count] == [cgColorArray count]) {
        layer.locations = floatNumArray;
    }
    layer.startPoint = aPoint;
    layer.endPoint = endPoint;
    [self.layer addSublayer:layer];
}

/**
 *  在UIView添加横线
 *  @param  hasUp   是不是添加上面
 *  @param  hasDown 是不是添加下面
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown
{
    [self addLineUp:hasUp andDown:hasDown andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

/**
 *  在UIView添加横线
 *  @param  hasUp   是不是添加上面
 *  @param  hasDown 是不是添加下面
 *  @param  color   线条的颜色
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor*)color
{
    [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0.f];
}

/**
 *  在UIView添加横线
 *  @param  hasUp       是不是添加上面
 *  @param  hasDown     是不是添加下面
 *  @param  color       线条的颜色
 *  @param  leftSpace   线条距离左边的距离
 **/
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor*)color andLeftSpace:(CGFloat)leftSpace
{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView* upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView* downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds) - 0.5 andColor:color andLeftSpace:leftSpace];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
}

/**
 *  删除一个View通过tag
 *  @param  tag   标识
 **/
- (void)removeViewWithTag:(NSInteger)tag
{
    for (UIView* aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}

- (CGRect)boundsWithoutStatBarAndNavBar
{
    CGRect frame = self.bounds;
    frame.size.height -= (kStateBarHeight + kNavBarHeight);
    return frame;
}

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY   横线的Y坐标
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY
{
    return [self lineViewWithPointYY:pointY andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY      横线的Y坐标
 *  @param  color       横线的颜色
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor*)color
{
    return [self lineViewWithPointYY:pointY andColor:color andLeftSpace:0.f];
}

/**
 *  得到一个带有横线的View，横线的Y坐标是pointY
 *  @param  pointY      横线的Y坐标
 *  @param  color       横线的颜色
 *  @param  leftSpace   横线距离左边的距离
 **/
+ (UIView*)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor*)color andLeftSpace:(CGFloat)leftSpace
{
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, kScreenWidth, 0.5)];
    lineView.backgroundColor = color;
    return lineView;
}

@end
