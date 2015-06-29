//
//  CMCameraView.h
//  POICollect
//  相机视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCameraView;

@protocol CMCameraViewDelegate <NSObject>

@optional
- (void)cameraDidSelected:(CMCameraView*)cameraView;

@end

@interface CMCameraView : UIView

@property (nonatomic, weak) id<CMCameraViewDelegate> delegate;

@end
