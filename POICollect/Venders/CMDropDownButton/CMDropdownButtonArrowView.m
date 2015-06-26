//
//  CMDropdownButtonArrowView.m
//  POICollect
//  箭头
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMDropdownButtonArrowView.h"

@implementation CMDropdownButtonArrowView

#pragma mark - 方法

+ (UIImage*)getArrowImageWithFrame:(CGRect)frame andWithBgcolor:(UIColor*)bgColor
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);

    UIBezierPath* indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath moveToPoint:CGPointMake(0, 0)];
    [indicatorPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), 0)];
    [indicatorPath addLineToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame))];
    [indicatorPath closePath];
    if (bgColor) {
        [bgColor setFill];
    }
    else {
        [kAppThemePrimaryColor setFill];
    }
    [indicatorPath fill];
    CGContextAddPath(ctx, indicatorPath.CGPath);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)getRightImageWithFrame:(CGRect)frame andWithBgcolor:(UIColor*)bgcolor
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);

    UIBezierPath* indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath moveToPoint:CGPointMake(CGRectGetWidth(frame) * 0.1, CGRectGetHeight(frame) * 0.45)];
    [indicatorPath addLineToPoint:CGPointMake(CGRectGetWidth(frame) * 0.45, CGRectGetHeight(frame) * 0.8)];
    [indicatorPath addLineToPoint:CGPointMake(CGRectGetWidth(frame) * 0.9, CGRectGetHeight(frame) * 0.3)];
    [indicatorPath setLineWidth:CGRectGetHeight(frame) / 10.0];
    if (bgcolor) {
        [bgcolor setStroke];
    }
    else {
        [kAppThemeThirdColor setStroke];
    }
    [indicatorPath stroke];
    CGContextAddPath(ctx, indicatorPath.CGPath);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
