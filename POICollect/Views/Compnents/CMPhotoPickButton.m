//
//  CMPhotoPickButton.m
//  POICollect
//  图片选择按钮
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickButton.h"
#import "UIView+CMExpened.h"
#import "CMPhotoKit.h"
#import "UIImage+Expanded.h"

#define kDefaultNormalBgColor [UIColor colorWithHexString:@"0xD1D1D1"]

static const CGFloat sDefaultBorderWidth = 4;
static const CGFloat sDefaultCornerRadius = 5;

@interface CMPhotoPickButton () <CMPhotoPickerViewControllerDelegate, UIActionSheetDelegate>

@end

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

    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
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

#pragma mark - CMPhotoPickerViewControllerDelegate

/**
 *  返回所有的Asstes对象
 */
- (void)pickerViewControllerDoneAsstes:(NSArray*)assets
{
    if (assets && assets.count > 0) {
        UIImage* tmpImage = nil;
        // 判断类型来获取Image
        _currentPhotoAsset = assets[0];
        if ([_currentPhotoAsset isKindOfClass:[CMPhotoAssets class]]) {
            tmpImage = _currentPhotoAsset.thumbImage;
        }
        else if ([_currentPhotoAsset isKindOfClass:[NSString class]]) {
            tmpImage = [UIImage imageWithURL:[NSURL URLWithString:(NSString*)_currentPhotoAsset]];
            //            [cell.imageview1 sd_setImageWithURL:[NSURL URLWithString:(NSString*)asset] placeholderImage:[UIImage imageNamed:@"wallpaper_placeholder"]];
        }
        else if ([_currentPhotoAsset isKindOfClass:[UIImage class]]) {
            tmpImage = (UIImage*)_currentPhotoAsset;
        }

        if (tmpImage) {
            tmpImage = [tmpImage scaleToSize:self.frame.size];
        }

        [self setBackgroundImage:tmpImage forState:UIControlStateNormal];
        [self setBackgroundImage:tmpImage forState:UIControlStateHighlighted];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
    case 0: {
        //拍照
    } break;
    case 1: {
        //相册
        CMPhotoPickerViewController* photoPickVC = [[CMPhotoPickerViewController alloc] init];
        photoPickVC.delegate = self;
        [photoPickVC show];
    } break;

    default:
        break;
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
