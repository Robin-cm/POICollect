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

+ (UIImage*)imageWithURL:(NSURL*)url
{
    NSData* data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

- (UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
