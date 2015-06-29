//
//  CMCameraPreviewTapView.h
//  POICollect
//
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMCameraPreviewTapViewDelegate <NSObject>

@optional

/**
 *  单击
 *
 *  @param view  视图
 *  @param touch 点击事件对象
 */
- (void)view:(UIView*)view singleTapDetected:(UITouch*)touch;

/**
 *  双击
 *
 *  @param view  视图
 *  @param touch 点击事件对象
 */
- (void)view:(UIView*)view doubleTapDetected:(UITouch*)touch;

@end

@interface CMCameraPreviewTapView : UIView

#pragma mark - 属性

@property (nonatomic, weak) id<CMCameraPreviewTapViewDelegate> tapDelegate;

@end
