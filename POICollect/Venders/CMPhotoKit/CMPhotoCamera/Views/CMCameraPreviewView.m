//
//  CMCameraPreviewView.m
//  POICollect
//  拍照预览视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraPreviewView.h"
#import "CMCameraPreviewImageScrollView.h"
#import "CMCamera.h"

static const CGFloat showDuration = 0.3;

static const CGFloat hideDuration = 0.2;

static const CGFloat toolbarHeight = 44;

@interface CMCameraPreviewView ()

@property (nonatomic, strong) CMCameraPreviewImageScrollView* previewScrollView;

@property (nonatomic, strong) UIButton* gobackBtn;

@property (nonatomic, strong) UIButton* doneBtn;

@property (nonatomic, strong) CMCamera* currentPhoto;

@property (nonatomic, strong) UIView* toolBarView;

@end

@implementation CMCameraPreviewView

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self) {
        if (parentViewController) {
            _parentViewController = parentViewController;
        }
        [self configView];
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

    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - toolbarHeight, kScreenWidth, toolbarHeight)];
        _toolBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_toolBarView];
    }

    if (!_gobackBtn) {
        _gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gobackBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
        [_gobackBtn setTitleColor:kAppThemeSecondaryColor forState:UIControlStateNormal];
        _gobackBtn.frame = CGRectMake(10, 0, 90, toolbarHeight);
        [_gobackBtn addTarget:self action:@selector(gobackBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_gobackBtn];
    }

    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:kAppThemeSecondaryColor forState:UIControlStateNormal];
        _doneBtn.frame = CGRectMake(kScreenWidth - 90 - 10, 0, 90, toolbarHeight);
        [_doneBtn addTarget:self action:@selector(doneBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_doneBtn];
    }
}

#pragma mark - 公共方法

- (void)showPreviewWithPhoto:(CMCamera*)photo
{
    _currentPhoto = photo;
    _previewScrollView.currentPhoto = photo;
    if (_parentViewController) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        [_parentViewController.view addSubview:self];
        self.alpha = 0;
        [UIView animateWithDuration:showDuration
            animations:^{
                self.alpha = 1.f;
            }
            completion:^(BOOL finished){

            }];
    }
}

- (void)hidePreview
{
    [UIView animateWithDuration:hideDuration
        animations:^{
            self.alpha = 0;
        }
        completion:^(BOOL finished) {
            _currentPhoto = nil;
            _previewScrollView.currentPhoto = nil;
            [self removeFromSuperview];
        }];
}

#pragma mark - 事件

- (void)gobackBtnTaped:(id)sender
{
    [self hidePreview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancalBtnTapedWithPreview:)]) {
        [self.delegate didCancalBtnTapedWithPreview:self];
    }
}

- (void)doneBtnTaped:(id)sender
{
    if (_currentPhoto) {
        [self hidePreview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDoneBtnTapedWithPreview:currentPhoto:)]) {
            [self.delegate didDoneBtnTapedWithPreview:self currentPhoto:_currentPhoto];
        }
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
