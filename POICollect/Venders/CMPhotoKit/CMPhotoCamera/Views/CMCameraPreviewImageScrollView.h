//
//  CMCameraPreviewImageScrollView.h
//  POICollect
//
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMCamera;

@protocol CMCameraPreviewImageScrollViewDelegate <NSObject>

@optional
//- (void)cameraPreviewImageScrollView

@end

@interface CMCameraPreviewImageScrollView : UIScrollView

#pragma mark - 属性

@property (nonatomic, strong) CMCamera* currentPhoto;

@end
