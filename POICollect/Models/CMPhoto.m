//
//  CMPhoto.m
//  POICollect
//  图片的模型
//  Created by 常敏 on 15/6/30.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhoto.h"
#import "UIImage+Expanded.h"
#import "NSString+validator.h"

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
        if (![self.imageURLString isBlankString]) {
            _originalImage = [UIImage imageWithContentsOfFile:self.imageURLString];
        }
    }
    return _originalImage;
}

- (UIImage*)thumbImage
{
    if (!_thumbImage) {
        if (![self.imageURLString isBlankString]) {
            _thumbImage = [self.originalImage scaleToSize:CGSizeMake(80, 80)];
        }
    }
    return _thumbImage;
}

/**
 *  删除图片文件
 */
- (void)deleteImageFile
{
    if ([self.imageURLString isBlankString]) {
        return;
    }
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.imageURLString]) {
        NSError* err;
        [fileManager removeItemAtPath:self.imageURLString error:&err];
    }
}

- (NSString*)getImageName
{
    if (![self.imageURLString isBlankString]) {
        NSArray* pathArray = [self.imageURLString componentsSeparatedByString:@"/"];
        if (pathArray && pathArray.count > 0) {
            NSString* imageName = [pathArray objectAtIndex:pathArray.count - 1];
            imageName = [imageName stringByAppendingString:@".jpg"];
            return imageName;
        }
        else {
            return @"";
        }
    }
    else {
        return @"";
    }
}

@end
