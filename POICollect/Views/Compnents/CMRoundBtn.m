//
//  CMRoundBtn.m
//  POICollect
//  圆形按钮
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMRoundBtn.h"
#import "UIColor+Expanded.h"
#import "UIImage+Expanded.h"

#define kDefaultBackgroundColor kAppThemePrimaryColor
#define kDefaultForegroundColor kAppThemeSecondaryColor

static const CGFloat sDefaultPaddingPersent = 0.2;
static const CGFloat sDefaultWidthPersent = 0.07;
//static const CGFloat sDefaultTrianglePersent = 0.5;
static const CGFloat sDefaultRectPaddingPersent = 0.3;
static const CGFloat sDefaultLineWidthPersent = 0.1;

@interface CMRoundBtn ()

@property (nonatomic, assign, readwrite) CMRoundBtnType currentBtnType;

@property (nonatomic, copy) UIColor* highlightBackgroundColor;

@property (nonatomic, strong) CAShapeLayer* backgroundLayer;

@property (nonatomic, strong) CAShapeLayer* icoLayer;

@property (nonatomic, assign) BOOL needToDisplay;

@end

@implementation CMRoundBtn

#pragma maek - 生命周期

- (void)layoutSubviews
{
    NSLog(@"宽度是：%f", CGRectGetWidth(self.bounds));

    _icoLayer.frame = self.bounds;

    //    [self setBackgroundImage:[UIImage roundImageWithColor:_normalBackgroundColor andWithFrame:self.bounds] forState:UIControlStateNormal];
    //    [self setBackgroundImage:[UIImage roundImageWithColor:_highlightBackgroundColor andWithFrame:self.bounds] forState:UIControlStateHighlighted];
}

#pragma mark - 初始化方法

- (id)initRoundBtnWithBtnType:(CMRoundBtnType)btnType
{

    return [self initRoundBtnWithFrame:CGRectZero andBtnType:btnType];
}

- (id)initRoundBtnWithFrame:(CGRect)frame andBtnType:(CMRoundBtnType)btnType
{
    return [self initRoundBtnWithFrame:frame andWithBtnType:btnType andBackgroundColor:kDefaultBackgroundColor andForegroundColor:kDefaultForegroundColor];
}

- (id)initRoundBtnWithBtnType:(CMRoundBtnType)btnType andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor
{
    return [self initRoundBtnWithFrame:CGRectZero andWithBtnType:btnType andBackgroundColor:backgroundColor andForegroundColor:foregroundColor];
}

- (id)initRoundBtnWithFrame:(CGRect)frame andWithBtnType:(CMRoundBtnType)btnType andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentBtnType = btnType;
        _normalBackgroundColor = backgroundColor;
        _normalForegroundColor = foregroundColor;
        [self configView];
    }
    return self;
}

#pragma mark - 继承

- (void)setHighlighted:(BOOL)highlighted
{
    _needToDisplay = highlighted != self.isHighlighted;
    [super setHighlighted:highlighted];
    if (_needToDisplay) {
        [self setNeedsDisplay];
    }
}

- (void)setTitle:(NSString*)title forState:(UIControlState)state
{
    return;
}

#pragma mark -

- (void)setNormalBackgroundColor:(UIColor*)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self configView];
}

#pragma mark - 自定义实例私有方法

- (void)configView
{
    self.showsTouchWhenHighlighted = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius = 4;

    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_backgroundLayer];
    }

    if (!_icoLayer) {
        _icoLayer = [CAShapeLayer layer];
        _icoLayer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_icoLayer];
    }

    _normalBackgroundColor = _normalBackgroundColor ? _normalBackgroundColor : kDefaultBackgroundColor;

    _highlightBackgroundColor = [_normalBackgroundColor darkenedColorWithBrightnessFloat:0.85];

    _normalForegroundColor = _normalForegroundColor ? _normalForegroundColor : kDefaultForegroundColor;

    //    self.backgroundColor = [UIColor clearColor];
    //    self.tintColor = [UIColor clearColor];
    //    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width / 2.0];
    //    _backgroundLayer.path = path.CGPath;
    NSLog(@"wo bei diao yong le ");
    if (self.isHighlighted) {
        [_highlightBackgroundColor setFill];
    }
    else {
        [_normalBackgroundColor setFill];
    }
    [path fill];
    //    _backgroundLayer.path = path.CGPath;

    UIBezierPath* iconPath = [UIBezierPath bezierPath];
    CGFloat rWidth = CGRectGetWidth(rect);
    CGFloat rHeight = CGRectGetHeight(rect);
    CGFloat rX = CGRectGetMinX(rect);
    CGFloat rY = CGRectGetMinY(rect);

    switch (_currentBtnType) {
    case TYPE_ADD:
        //        NSLog(@"第一个点的坐标是：%f -- %f", rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight * sDefaultPaddingPersent));
        [iconPath moveToPoint:CGPointMake(rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight * sDefaultPaddingPersent))];
        //        NSLog(@"第二个点的坐标是：%f -- %f", rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第三个点的坐标是：%f -- %f", rX + rWidth * sDefaultPaddingPersent, rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * sDefaultPaddingPersent, rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第四个点的坐标是：%f -- %f", rX + rWidth * sDefaultPaddingPersent, rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * sDefaultPaddingPersent, rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第五个点的坐标是：%f -- %f", rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第六个点的坐标是：%f -- %f", rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight * (1 - sDefaultPaddingPersent)));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) - (rWidth * sDefaultWidthPersent), rY + (rHeight * (1 - sDefaultPaddingPersent)))];
        //        NSLog(@"第七个点的坐标是：%f -- %f", rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight * (1 - sDefaultPaddingPersent)));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight * (1 - sDefaultPaddingPersent)))];
        //        NSLog(@"第八个点的坐标是：%f -- %f", rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第九个点的坐标是：%f -- %f", rX + rWidth * (1 - sDefaultPaddingPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultPaddingPersent), rY + (rHeight / 2.0) + (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第十个点的坐标是：%f -- %f", rX + rWidth * (1 - sDefaultPaddingPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultPaddingPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第十一个点的坐标是：%f -- %f", rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent));
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + (rHeight / 2.0) - (rHeight * sDefaultWidthPersent))];
        //        NSLog(@"第十二个点的坐标是：%f -- %f", rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + rHeight * sDefaultPaddingPersent);
        [iconPath addLineToPoint:CGPointMake(rX + (rWidth / 2.0) + (rWidth * sDefaultWidthPersent), rY + rHeight * sDefaultPaddingPersent)];
        [iconPath closePath];
        [_normalForegroundColor setFill];
        [iconPath fill];
        _icoLayer.path = iconPath.CGPath;
        break;
    case TYPE_PLAY:

        break;
    case TYPE_STOP:
        //        NSLog(@"第一个点的坐标是：%f -- %f", rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * sDefaultRectPaddingPersent);
        [iconPath moveToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * sDefaultRectPaddingPersent)];
        //        NSLog(@"第二个点的坐标是：%f -- %f", rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * (1 - sDefaultRectPaddingPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        //        NSLog(@"第三个点的坐标是：%f -- %f", rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * (1 - sDefaultRectPaddingPersent));
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        //        NSLog(@"第四个点的坐标是：%f -- %f", rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * sDefaultRectPaddingPersent);
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * sDefaultRectPaddingPersent)];

        [iconPath closePath];
        [_normalForegroundColor setFill];
        [iconPath fill];
        _icoLayer.path = iconPath.CGPath;
        break;
    case TYPE_CLOSE:
        [iconPath moveToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * sDefaultRectPaddingPersent)];
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        [iconPath moveToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent, rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent), rY + rHeight * sDefaultRectPaddingPersent)];
        [iconPath setLineWidth:rWidth * sDefaultLineWidthPersent];
        [_normalForegroundColor setStroke];
        [iconPath stroke];
        _icoLayer.path = iconPath.CGPath;
        break;
    case TYPE_PAUSE:
        [iconPath moveToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent + (rWidth * sDefaultLineWidthPersent), rY + rHeight * sDefaultRectPaddingPersent)];
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * sDefaultRectPaddingPersent + (rWidth * sDefaultLineWidthPersent), rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        [iconPath moveToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent) - (rWidth * sDefaultLineWidthPersent), rY + rHeight * sDefaultRectPaddingPersent)];
        [iconPath addLineToPoint:CGPointMake(rX + rWidth * (1 - sDefaultRectPaddingPersent) - (rWidth * sDefaultLineWidthPersent), rY + rHeight * (1 - sDefaultRectPaddingPersent))];
        [iconPath setLineWidth:rWidth * sDefaultLineWidthPersent];
        [_normalForegroundColor setStroke];
        [iconPath stroke];
        _icoLayer.path = iconPath.CGPath;
        break;

    default:
        break;
    }
}

@end
