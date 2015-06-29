//
//  CMCameraViewController.h
//  POICollect
//  照相机的控制器
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^codeBlock)();
typedef void (^CMComplete)(id obj);

@interface CMCameraViewController : UIViewController

#pragma mark - 方法

- (void)startCameraOrPhotoFileWithComplate:(CMComplete)complete;

@end
