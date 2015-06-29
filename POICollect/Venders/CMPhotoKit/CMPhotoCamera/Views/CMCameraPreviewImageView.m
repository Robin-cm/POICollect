//
//  CMCameraPreviewImageView.m
//  POICollect
//  图像
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraPreviewImageView.h"

@interface CMCameraPreviewImageView ()

@property (nonatomic, strong) UITapGestureRecognizer* scaleBigTap;

@end

@implementation CMCameraPreviewImageView

#pragma mark - 继承方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configGesture];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)image
{
    self = [super initWithImage:image];
    if (self) {
        [self configGesture];
    }
    return self;
}

#pragma mark - 自定义方法

- (void)configGesture
{
    self.userInteractionEnabled = YES;
    if (!_scaleBigTap) {
        _scaleBigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _scaleBigTap.numberOfTapsRequired = 2;
        _scaleBigTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_scaleBigTap];
    }
}

#pragma mark - 事件

- (void)handleDoubleTap:(UITouch*)touch
{
    if (self.tapDelegate && [self.tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)]) {
        [self.tapDelegate imageView:self doubleTapDetected:touch];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
