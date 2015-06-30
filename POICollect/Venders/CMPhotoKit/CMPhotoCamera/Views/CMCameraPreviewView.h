//
//  CMCameraPreviewView.h
//  POICollect
//  拍照预览视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCamera;
@class CMCameraPreviewView;

@protocol CMCameraPreviewViewDelegate <NSObject>

@optional

- (void)didCancalBtnTapedWithPreview:(CMCameraPreviewView*)preview;

- (void)didDoneBtnTapedWithPreview:(CMCameraPreviewView*)preview currentPhoto:(CMCamera*)photo;

@end

@interface CMCameraPreviewView : UIView

@property (nonatomic, strong) UIViewController* parentViewController;

@property (nonatomic, weak) id<CMCameraPreviewViewDelegate> delegate;

#pragma mark - 处事方法

- (id)initWithParentViewController:(UIViewController*)parentViewController;

#pragma mark - 公共方法

- (void)showPreviewWithPhoto:(CMCamera*)photo;

- (void)hidePreview;

@end
