//
//  CMPhotoAssets.m
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoAssets.h"

@implementation CMPhotoAssets

- (UIImage*)thumbImage
{
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}

- (UIImage*)originImage
{
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}

- (BOOL)isVideoType
{
    NSString* type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

@end
