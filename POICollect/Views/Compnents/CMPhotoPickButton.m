//
//  CMPhotoPickButton.m
//  POICollect
//  图片选择按钮
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickButton.h"
#import "UIView+CMExpened.h"

#define kDefaultNormalBgColor [UIColor colorWithHexString:@"0xD1D1D1"]

static const CGFloat sDefaultBorderWidth = 4;
static const CGFloat sDefaultCornerRadius = 5;

@implementation CMPhotoPickButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 50, 50);
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

#pragma mark -  自定义

- (void)configView
{

    [self circleCornerWithRadius:sDefaultBorderWidth];

    _normalBgImage = [self getDefaultImageWithFrame:self.bounds andWithBgColor:kDefaultNormalBgColor];
    _highlightBgImage = [self getDefaultImageWithFrame:self.bounds andWithBgColor:[kDefaultNormalBgColor darkenedColorWithBrightnessFloat:0.8]];

    [self setBackgroundImage:_normalBgImage forState:UIControlStateNormal];
    [self setBackgroundImage:_highlightBgImage forState:UIControlStateHighlighted];

    if (![[self allTargets] containsObject:self]) {
        [self addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 事件

- (void)btnTaped:(id)sender
{
    NSLog(@"我已经点击了!");
}

#pragma mark - 公共方法

- (UIImage*)getDefaultImageWithFrame:(CGRect)frame andWithBgColor:(UIColor*)bgColor
{
    CGRect rect = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);

    // circle Drawing
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:sDefaultCornerRadius];
    [bgColor setStroke];
    rectPath.lineWidth = sDefaultBorderWidth;
    [rectPath stroke];
    CGContextAddPath(context, rectPath.CGPath);

    UIBezierPath* vLinePath = [UIBezierPath bezierPath];
    [vLinePath moveToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetHeight(frame) * 0.25)];
    [vLinePath addLineToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetHeight(frame) * 0.75)];
    [vLinePath setLineWidth:sDefaultBorderWidth];
    [vLinePath stroke];
    CGContextAddPath(context, vLinePath.CGPath);

    UIBezierPath* hLinePath = [UIBezierPath bezierPath];
    [hLinePath moveToPoint:CGPointMake(CGRectGetWidth(frame) * 0.25, CGRectGetMidY(frame))];
    [hLinePath addLineToPoint:CGPointMake(CGRectGetWidth(frame) * 0.75, CGRectGetMidY(frame))];
    [hLinePath setLineWidth:sDefaultBorderWidth];
    [hLinePath stroke];
    CGContextAddPath(context, hLinePath.CGPath);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
