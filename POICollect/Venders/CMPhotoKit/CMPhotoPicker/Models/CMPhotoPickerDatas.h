//
//  CMPhotoPickerDatas.h
//  POICollect
//
//  Created by 敏梵 on 15/6/26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPhotoPickerGroup.h"

typedef void (^callbackBlock)(id obj);

@interface CMPhotoPickerDatas : NSObject

#pragma mark - 方法

+ (CMPhotoPickerDatas*)sharePhotoPickerData;

- (void)getAllGroupsWithPhotos:(callbackBlock)block;

- (void)getAllGroupsWithVideos:(callbackBlock)block;

/**
 *  传入一个组获取组里面的Asset
 */
- (void)getGroupPhotosWithGroup:(CMPhotoPickerGroup*)pickerGroup finished:(callbackBlock)callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void)getAssetsPhotoWithURLs:(NSURL*)url callBack:(callbackBlock)callBack;

/**
 *  传入一个图片对象（ALAsset、URL）
 *
 *  @return 返回图片
 */
- (UIImage*)getImageWithImageObj:(id)imageObj;

@end
