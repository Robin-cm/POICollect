//
//  CMPhoto.h
//  POICollect
//  图片的模型
//  Created by 常敏 on 15/6/30.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPhoto : NSObject

/**
 *  原始图片
 */
@property (nonatomic, strong, readonly) UIImage* originalImage;

/**
 *  缩略图
 */
@property (nonatomic, strong, readonly) UIImage* thumbImage;

/**
 *  路径
 */
@property (nonatomic, strong) NSString* imageURLString;

/**
 *  是不是本地的图片，false是拍照来的图片 
 */
@property (nonatomic, assign) BOOL localImage;

@end
