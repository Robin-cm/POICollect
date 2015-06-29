//
//  CMCamera.m
//  POICollect
//
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCamera.h"

@implementation CMCamera

- (UIImage*)fullScreenImage
{
    return [UIImage imageWithContentsOfFile:self.imagePath];
}

@end
