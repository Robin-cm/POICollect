//
//  CMPhotoPickerImageView.m
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerImageView.h"

@interface CMPhotoPickerImageView ()

@property (nonatomic, weak) UIView* maskView;
@property (nonatomic, weak) UIImageView* tickImageView;
@property (nonatomic, weak) UIImageView* videoView;

@end

@implementation CMPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Getter

- (UIView*)maskView
{
    if (!_maskView) {
        UIView* maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.alpha = 0.5;
        maskView.hidden = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}

- (UIImageView*)videoView
{
    if (!_videoView) {
        UIImageView* videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        videoView.image = [UIImage imageNamed:@"video"];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
}

- (UIImageView*)tickImageView
{
    if (!_tickImageView) {
        UIImageView* tickImageView = [[UIImageView alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
        tickImageView.image = [UIImage imageNamed:@"AssetsPickerChecked"];
        tickImageView.hidden = YES;
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
    }
    return _tickImageView;
}

#pragma mark - Setter

- (void)setIsVideoType:(BOOL)isVideoType
{
    _isVideoType = isVideoType;

    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag
{
    _maskViewFlag = maskViewFlag;

    self.maskView.hidden = !maskViewFlag;
    self.animationRightTick = maskViewFlag;
}

- (void)setMaskViewColor:(UIColor*)maskViewColor
{
    _maskViewColor = maskViewColor;

    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha
{
    _maskViewAlpha = maskViewAlpha;

    self.maskView.alpha = maskViewAlpha;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick
{
    _animationRightTick = animationRightTick;
    self.tickImageView.hidden = !animationRightTick;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
