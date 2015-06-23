//
//  UIImage+Expanded.m
//  POICollect
//
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UIImage+Expanded.h"

@implementation UIImage (Expanded)

+ (UIImage*)imageWithColor:(UIColor*)color
{
    return [UIImage imageWithColor:color andWithFrame:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage*)imageWithColor:(UIColor*)color andWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, frame);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)roundImageWithColor:(UIColor*)color andWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, frame);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
