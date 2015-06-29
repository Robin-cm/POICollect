//
//  CMCameraPreviewTapView.m
//  POICollect
//  点击视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraPreviewTapView.h"

@interface CMCameraPreviewTapView ()

@property (nonatomic, strong) UITapGestureRecognizer* scaleBigTap;

@end

@implementation CMCameraPreviewTapView

#pragma mark - 初始化方法

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

- (void)dealloc
{
    if (_scaleBigTap) {
        [self removeGestureRecognizer:_scaleBigTap];
        _scaleBigTap = nil;
    }
}

#pragma mark - 自定义方法

- (void)configGesture
{
    self.userInteractionEnabled = YES;

    if (!_scaleBigTap) {
        _scaleBigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _scaleBigTap.numberOfTapsRequired = 2;
        _scaleBigTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_scaleBigTap];
    }
}

#pragma mark - 事件

- (void)handleSingleTap:(UITouch*)touch
{
    if (self.tapDelegate && [self.tapDelegate respondsToSelector:@selector(view:singleTapDetected:)]) {
        [self.tapDelegate view:self doubleTapDetected:touch];
    }
}

- (void)handleDoubleTap:(UITouch*)touch
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
