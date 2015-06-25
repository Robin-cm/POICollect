//
//  CMSimpleCheckBoxBtn.m
//  POICollect
//  自定义的checkbox按钮
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

static CGFloat const sDefaultLargeSize = 90;
static CGFloat const sDefaultBigSize = 70;
static CGFloat const sDefaultMidSize = 50;
static CGFloat const sDefaultSmallSize = 30;
static CGFloat const sDefaultTintSize = 20;

static CGFloat const sDefaultBorderWidth = 1;
static CGFloat const sDefaultCornerRadius = 5;

#define kDefaultBtnBackgroundColor [UIColor colorWithHexString:@"0xff4d4d"]
#define kDefaultBorderColor [UIColor colorWithHexString:@"0xFF464F"]
#define kDefaultBtnForegroundColor [UIColor colorWithHexString:@"0xFEFFFD"]

#import "CMSimpleCheckBoxBtn.h"

@interface CMSimpleCheckBoxBtn ()

@property (nonatomic, assign) CMSimpleCheckBoxBtnSize currentSize;

@end

@implementation CMSimpleCheckBoxBtn

#pragma mark - 继承

#pragma mark - 初始化方法

- (id)initBoxButtonWithSize:(CMSimpleCheckBoxBtnSize)size
{
    self = [super initWithFrame:[CMSimpleCheckBoxBtn configSize:size]];
    if (self) {
        _currentSize = size;
        [self configView];
    }
    return self;
}

#pragma mark - Setter

- (void)setBorderColor:(UIColor*)borderColor
{
}

- (void)setNormalIco:(UIImage*)normalIco
{
}

- (void)setSelectedIco:(UIImage*)selectedIco
{
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
}

- (void)setBtnBackgroundColor:(UIColor*)btnBackgroundColor
{
}

- (void)setBtnForegroundColor:(UIColor*)btnForegroundColor
{
}

#pragma mark - 自定义方法

+ (CGRect)configSize:(CMSimpleCheckBoxBtnSize)size
{
    CGRect mFrame = CGRectZero;
    switch (size) {
    case CMSimpleCheckBoxBtnSize_Large:
        mFrame = CGRectMake(0, 0, sDefaultLargeSize, sDefaultLargeSize);
        break;
    case CMSimpleCheckBoxBtnSize_Big:
        mFrame = CGRectMake(0, 0, sDefaultBigSize, sDefaultBigSize);
        break;
    case CMSimpleCheckBoxBtnSize_Mid:
        mFrame = CGRectMake(0, 0, sDefaultMidSize, sDefaultMidSize);
        break;
    case CMSimpleCheckBoxBtnSize_Small:
        mFrame = CGRectMake(0, 0, sDefaultSmallSize, sDefaultSmallSize);
        break;
    case CMSimpleCheckBoxBtnSize_Tint:
        mFrame = CGRectMake(0, 0, sDefaultTintSize, sDefaultTintSize);
        break;
    default:
        mFrame = CGRectMake(0, 0, sDefaultSmallSize, sDefaultSmallSize);
        break;
    }
    return mFrame;
}

- (void)configView
{
    _btnBackgroundColor = _btnBackgroundColor ?: kDefaultBtnBackgroundColor;

    _btnForegroundColor = _btnForegroundColor ?: kDefaultBtnForegroundColor;

    _borderColor = _borderColor ?: kDefaultBorderColor;

    _borderWidth = _borderWidth ?: sDefaultBorderWidth;
}

- (void)reDrawButton
{
    if (!self.normalIco) {
        _normalIco = [self drawIconWithSelection:NO];
    }
    if (!self.selectedIco) {
        _selectedIco = [self drawIconWithSelection:YES];
    }
    if (![self imageForState:UIControlStateNormal] || ![self imageForState:UIControlStateSelected]) {
        [self setImage:self.normalIco forState:UIControlStateNormal];
        [self setImage:self.selectedIco forState:UIControlStateSelected];
    }

    if (![[self allTargets] containsObject:self]) {
        [super addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UIImage*)drawIconWithSelection:(BOOL)selected
{
    CGRect targetFrame = [CMSimpleCheckBoxBtn configSize:_currentSize];

    CGRect rect = CGRectMake(0.0, 0.0, CGRectGetWidth(targetFrame), CGRectGetHeight(targetFrame));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);

    // circle Drawing
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:sDefaultCornerRadius];
    //    UIBezierPath* rectPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(buttonSideLength / 2 - circleRadius, buttonSideLength / 2 - circleRadius, circleRadius * 2, circleRadius * 2)];
    [_borderColor setStroke];
    [_btnBackgroundColor setFill];
    rectPath.lineWidth = _borderWidth;
    [rectPath stroke];
    [rectPath fill];
    CGContextAddPath(context, rectPath.CGPath);

    if (selected) {
        UIBezierPath* indicatorPath = [UIBezierPath bezierPath];
        [indicatorPath moveToPoint:CGPointMake(CGRectGetWidth(rect) * 0.1, CGRectGetHeight(rect) * 0.45)];
        [indicatorPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) * 0.45, CGRectGetHeight(rect) * 0.8)];
        [indicatorPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) * 0.9, CGRectGetHeight(rect) * 0.3)];
        [indicatorPath setLineWidth:CGRectGetHeight(rect) / 10.0];
        [_btnForegroundColor setStroke];
        [indicatorPath stroke];
        CGContextAddPath(context, indicatorPath.CGPath);
    }

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 事件

- (void)touchDown:(id)sender
{
    self.selected = !self.selected;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [self reDrawButton];
}

@end
