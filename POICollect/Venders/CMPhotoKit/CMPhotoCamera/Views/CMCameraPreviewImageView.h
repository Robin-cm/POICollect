//
//  CMCameraPreviewImageView.h
//  POICollect
//
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMCameraPreviewImageViewDelegate <NSObject>

@optional

/**
 *  双击
 *
 *  @param imageView 图片
 *  @param touch     事件对象
 */
- (void)imageView:(UIImageView*)imageView doubleTapDetected:(UITouch*)touch;

@end

@interface CMCameraPreviewImageView : UIImageView

@property (nonatomic, weak) id<CMCameraPreviewImageViewDelegate> tapDelegate;

@end
