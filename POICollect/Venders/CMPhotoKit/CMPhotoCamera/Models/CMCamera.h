//
//  CMCamera.h
//  POICollect
//  照相的实体类
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCamera : NSObject

@property (nonatomic, copy) NSString* imagePath;

@property (nonatomic, strong) UIImage* thumbImage;

@property (nonatomic, strong) UIImage* fullScreenImage;

@end
