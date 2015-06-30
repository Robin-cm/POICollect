//
//  CMPhotoPickButton.h
//  POICollect
//  图片选择按钮
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPhotoAssets;
@class CMPhoto;

@interface CMPhotoPickButton : UIButton

#pragma mark - 属性

@property (nonatomic, strong) UIImage* normalBgImage;
@property (nonatomic, strong) UIImage* highlightBgImage;

@property (nonatomic, strong) CMPhotoAssets* currentPhotoAsset;

@property (nonatomic, strong) CMPhoto* currentPhoto;

#pragma mark - 初始化

#pragma mark - 公共方法

@end