//
//  CMCameraPreviewImageScrollView.m
//  POICollect
//
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraPreviewImageScrollView.h"
#import "CMCamera.h"
#import "CMCameraPreviewTapView.h"
#import "CMCameraPreviewImageView.h"

@interface CMCameraPreviewImageScrollView () <CMCameraPreviewTapViewDelegate, CMCameraPreviewImageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) CMCameraPreviewImageView* previewImageView;

@property (nonatomic, strong) CMCameraPreviewTapView* previewTapView;

@end

@implementation CMCameraPreviewImageScrollView

#pragma mark - 继承方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

#pragma mark - 生命周期

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _previewImageView.frame;

    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    }
    else {
        frameToCenter.origin.x = 0;
    }

    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    }
    else {
        frameToCenter.origin.y = 0;
    }

    // Center
    if (!CGRectEqualToRect(_previewImageView.frame, frameToCenter))
        _previewImageView.frame = frameToCenter;
}

#pragma mark - Setter

- (void)setCurrentPhoto:(CMCamera*)currentPhoto
{
    _currentPhoto = currentPhoto;
    if (_currentPhoto.fullScreenImage) {
        _previewImageView.image = _currentPhoto.fullScreenImage;
    }
    [self displayImage];
}

#pragma mark - 自定义方法

- (void)configView
{
    if (!_previewTapView) {
        _previewTapView = [[CMCameraPreviewTapView alloc] initWithFrame:self.bounds];
        _previewTapView.tapDelegate = self;
        _previewTapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _previewTapView.backgroundColor = [UIColor blackColor];
        [self addSubview:_previewTapView];
    }

    if (!_previewImageView) {
        _previewImageView = [[CMCameraPreviewImageView alloc] initWithFrame:CGRectZero];
        _previewImageView.tapDelegate = self;
        _previewImageView.contentMode = UIViewContentModeCenter;
        _previewImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_previewImageView];
    }

    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)displayImage
{
    self.maximumZoomScale = 1.f;
    self.minimumZoomScale = 1.f;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);

    UIImage* img = _previewImageView.image;
    if (img) {
        _previewImageView.image = img;
        _previewImageView.hidden = NO;

        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = img.size;
        _previewImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;

        [self setMaxMinZoomScalesForCurrentBounds];
    }
    [self setNeedsLayout];
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;

    if (_previewImageView.image == nil) {
        return;
    }

    _previewImageView.frame = CGRectMake(0, 0, _previewImageView.frame.size.width, _previewImageView.frame.size.height);

    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _previewImageView.image.size;

    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width; // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height; // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale); // use minimum of these to allow the image to become fully visible

    // Calculate Max
    CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }

    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }

    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;

    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];

    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
            (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }

    // Layout
    [self setNeedsLayout];
}

- (CGFloat)initialZoomScaleWithMinScale
{
    CGFloat zoomScale = self.minimumZoomScale;
    if (_previewImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _previewImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;

        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = xScale;
        }
    }
    return zoomScale;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _previewImageView;
}

- (void)scrollViewDidZoom:(UIScrollView*)scrollView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
