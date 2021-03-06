//
//  UIImage+Expanded.h
//  POICollect
//
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface UIImage (Expanded)

+ (UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage*)imageWithColor:(UIColor*)color andWithFrame:(CGRect)frame;

+ (UIImage*)roundImageWithColor:(UIColor*)color andWithFrame:(CGRect)frame;

+ (UIImage*)imageWithURL:(NSURL*)url;

- (UIImage*)scaleToSize:(CGSize)size;

- (NSString*)saveImageToDocument;

@end
