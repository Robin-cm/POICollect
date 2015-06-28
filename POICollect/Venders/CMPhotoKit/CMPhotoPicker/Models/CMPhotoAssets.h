//
//  CMPhotoAssets.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CMPhotoAssets : NSObject

@property (strong, nonatomic) ALAsset* asset;
/**
 *  缩略图
 */
- (UIImage*)thumbImage;
/**
 *  原图
 */
- (UIImage*)originImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign, nonatomic) BOOL isVideoType;

@end
