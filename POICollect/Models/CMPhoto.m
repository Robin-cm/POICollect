//
//  CMPhoto.m
//  POICollect
//  图片的模型
//  Created by 常敏 on 15/6/30.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhoto.h"
#import "UIImage+Expanded.h"

@interface CMPhoto ()

/**
 *  原始图片
 */
@property (nonatomic, strong, readwrite) UIImage* originalImage;

/**
 *  缩略图
 */
@property (nonatomic, strong, readwrite) UIImage* thumbImage;

@end

@implementation CMPhoto

#pragma mark - Getter

- (UIImage*)originalImage
{
    if (!_originalImage) {
        if (self.imageURLString) {
            _originalImage = [UIImage imageWithContentsOfFile:self.imageURLString];
        }
    }
    return _originalImage;
}

- (UIImage*)thumbImage
{
    if (!_thumbImage) {
        if (self.originalImage) {
            _thumbImage = [self.originalImage scaleToSize:CGSizeMake(80, 80)];
        }
    }
    return _thumbImage;
}

@end
