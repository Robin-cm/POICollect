//
//  CMCameraPreviewView.m
//  POICollect
//  拍照预览视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraPreviewView.h"
#import "CMCameraPreviewImageScrollView.h"

@interface CMCameraPreviewView ()

@property (nonatomic, strong) CMCameraPreviewImageScrollView* previewScrollView;

@property (nonatomic, strong) UIButton* gobackBtn;

@property (nonatomic, strong) UIButton* doneBtn;

@end

@implementation CMCameraPreviewView

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - 自定义方法

- (void)configView
{
    self.backgroundColor = [UIColor blackColor];
    self.frame = kScreenBounds;

    if (!_previewScrollView) {
        _previewScrollView = [[CMCameraPreviewImageScrollView alloc] init];
        _previewScrollView.frame = self.bounds;
        [self addSubview:_previewScrollView];
    }

    if (!_gobackBtn) {
        _gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gobackBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
        _gobackBtn.frame = CGRectMake(10, kScreenHeight - 25 - 10, 50, 25);
        [self addSubview:_gobackBtn];
    }

    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        _doneBtn.frame = CGRectMake(kScreenWidth - 50 - 10, kScreenHeight - 25 - 10, 50, 25);
        [self addSubview:_doneBtn];
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
