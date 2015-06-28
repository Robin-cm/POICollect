//
//  CMPhotoPickerImageView.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPhotoPickerImageView : UIImageView

/**
 *  是否有蒙版层
 */
@property (nonatomic, assign, getter=isMaskViewFlag) BOOL maskViewFlag;
/**
 *  蒙版层的颜色,默认白色
 */
@property (nonatomic, strong) UIColor* maskViewColor;
/**
 *  蒙版的透明度,默认 0.5
 */
@property (nonatomic, assign) CGFloat maskViewAlpha;
/**
 *  是否有右上角打钩的按钮
 */
@property (nonatomic, assign) BOOL animationRightTick;
/**
 *  是否视频类型
 */
@property (assign, nonatomic) BOOL isVideoType;

@end
