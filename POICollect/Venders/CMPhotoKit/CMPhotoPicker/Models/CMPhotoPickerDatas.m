//
//  CMPhotoPickerDatas.m
//  POICollect
//  图片数据类,单例
//  Created by 敏梵 on 15/6/26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerDatas.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CMPhotoPickerGroup.h"

@interface CMPhotoPickerDatas ()

@property (nonatomic, strong) ALAssetsLibrary* library;

@end

@implementation CMPhotoPickerDatas

+ (CMPhotoPickerDatas*)sharePhotoPickerData
{
    static CMPhotoPickerDatas* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[CMPhotoPickerDatas alloc] init];
        }
    });
    return instance;
}

#pragma mark - 私有方法

+ (ALAssetsLibrary*)defaultAssetsLibrary
{
    static ALAssetsLibrary* lib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!lib) {
            lib = [[ALAssetsLibrary alloc] init];
        }
    });
    return lib;
}

- (void)getAllGroupAllPhotos:(BOOL)allPhotos withResource:(callbackBlock)callBack
{
    NSMutableArray* groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup* group, BOOL* stop) {
        if (group) {
            if (allPhotos) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            }
            else {
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }

            CMPhotoPickerGroup* pickerGroup = [[CMPhotoPickerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }
        else {
            callBack(groups);
        }
    };
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:resultBlock
                              failureBlock:^(NSError* error){

                              }];
}

#pragma mark - Getter

- (ALAssetsLibrary*)library
{
    if (!_library) {
        _library = [CMPhotoPickerDatas defaultAssetsLibrary];
    }
    return _library;
}

#pragma mark - 方法

- (void)getAllGroupsWithPhotos:(callbackBlock)block
{
    [self getAllGroupAllPhotos:YES withResource:block];
}

- (void)getAllGroupsWithVideos:(callbackBlock)block
{
    [self getAllGroupAllPhotos:NO withResource:block];
}

/**
 *  传入一个组获取组里面的Asset
 */
- (void)getGroupPhotosWithGroup:(CMPhotoPickerGroup*)pickerGroup finished:(callbackBlock)callBack
{
    NSMutableArray* assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset* asset, NSUInteger index, BOOL* stop) {
        if (asset) {
            [assets addObject:asset];
        }
        else {
            callBack(assets);
        }
    };
    [pickerGroup.group enumerateAssetsUsingBlock:result];
}

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void)getAssetsPhotoWithURLs:(NSURL*)url callBack:(callbackBlock)callBack
{
    [self.library assetForURL:url
                  resultBlock:^(ALAsset* asset) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
                      });
                  }
                 failureBlock:nil];
}

/**
 *  传入一个图片对象（ALAsset、URL）
 *
 *  @return 返回图片
 */
- (UIImage*)getImageWithImageObj:(id)imageObj
{
    __block UIImage* image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        image = imageObj;
    }
    else if ([imageObj isKindOfClass:[ALAsset class]]) {
        ALAsset* asset = (ALAsset*)imageObj;
        image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    }
    else if ([imageObj isKindOfClass:[NSURL class]]) {
        image = imageObj;
    }
    return image;
}

@end
