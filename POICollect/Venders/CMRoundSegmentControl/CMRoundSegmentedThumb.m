//
//  CMRoundSegmentedThumb.m
//  POICollect
//  滑动的块儿
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMRoundSegmentedThumb.h"
#import "CMRoundSegmentControl.h"

@interface CMRoundSegmentedThumb ()

@property (nonatomic, readwrite) BOOL mSelected;
@property (nonatomic, readonly, getter=segmentedControl) CMRoundSegmentControl* mSegmentedControl;

@property (nonatomic, readwrite) UILabel* mFirstLabel;
@property (nonatomic, readwrite) UILabel* mSecendLabel;

@end

@implementation CMRoundSegmentedThumb

@synthesize mThumbTintColor = _mThumbTintColor;
@synthesize mThumbBackgroundColor = _mThumbBackgroundColor;
@synthesize mFont = _mFont;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        //        self.mTextColor = [UIColor whiteColor];
        //        self.mTintColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected
{
    _mSelected = selected;
    if (_mSelected) {
        self.alpha = 0.8;
    }
    else {
        self.alpha = 1.0;
    }
}

- (void)setMThumbTintColor:(UIColor*)mThumbTintColor
{
    if (!mThumbTintColor) {
        return;
    }
    _mThumbTintColor = mThumbTintColor;
    self.firstLabel.textColor = _mThumbTintColor;
    self.secendLabel.textColor = _mThumbTintColor;
}

- (void)setMThumbBackgroundColor:(UIColor*)mThumbBackgroundColor
{
    if (!mThumbBackgroundColor) {
        return;
    }
    _mThumbBackgroundColor = mThumbBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setMFont:(UIFont*)mFont
{
    if (!mFont) {
        return;
    }
    _mFont = mFont;
    self.firstLabel.font = _mFont;
    self.secendLabel.font = _mFont;
}

#pragma mark - getter

- (UIColor*)mThumbTintColor
{
    if (!_mThumbTintColor) {
        _mThumbTintColor = self.segmentedControl.mSelectedTextColor;
    }
    return _mThumbTintColor;
}

- (UIColor*)mThumbBackgroundColor
{
    if (!_mThumbBackgroundColor) {
        _mThumbBackgroundColor = self.segmentedControl.mThumbColor;
    }
    return _mThumbBackgroundColor;
}

- (UIFont*)mFont
{
    return self.segmentedControl.mFont;
}

- (UILabel*)firstLabel
{
    if (_mFirstLabel == nil) {
        _mFirstLabel = [[UILabel alloc] initWithFrame:self.bounds];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        _mFirstLabel.textAlignment = UITextAlignmentCenter;
#else
        _mFirstLabel.textAlignment = NSTextAlignmentCenter;
#endif
        _mFirstLabel.font = self.mFont;
        _mFirstLabel.textColor = self.mThumbTintColor;
        _mFirstLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_mFirstLabel];
    }

    return _mFirstLabel;
}

- (UILabel*)secendLabel
{
    if (_mSecendLabel == nil) {
        _mSecendLabel = [[UILabel alloc] initWithFrame:self.bounds];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        _mSecendLabel.textAlignment = UITextAlignmentCenter;
#else
        _mSecendLabel.textAlignment = NSTextAlignmentCenter;
#endif
        _mSecendLabel.font = self.mFont;
        _mSecendLabel.textColor = self.mThumbTintColor;
        _mSecendLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_mSecendLabel];
    }

    return _mSecendLabel;
}

- (CMRoundSegmentControl*)segmentedControl
{
    return (CMRoundSegmentControl*)self.superview;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{

    NSLog(@"小的块儿被重新画了一次");
    // Drawing code
    CGRect thumbRect = CGRectMake(self.mSegmentedControl.mThumbEdgeInset.left,
        self.mSegmentedControl.mThumbEdgeInset.top,
        rect.size.width - self.mSegmentedControl.mThumbEdgeInset.left - self.mSegmentedControl.mThumbEdgeInset.right,
        rect.size.height - self.mSegmentedControl.mThumbEdgeInset.top - self.mSegmentedControl.mThumbEdgeInset.bottom); // 1 is for segmented bottom gloss

    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:thumbRect cornerRadius:thumbRect.size.height / 2.f];
    [self.mThumbBackgroundColor setFill];
    [path fill];
    //    CGPathRelease(path.CGPath);
    NSLog(@"小的块儿执行完成一次");
}

- (void)setTitle:(NSString*)title
{
    [UIView setAnimationsEnabled:NO];

    self.firstLabel.text = title;
    [self arrangeLabel:self.firstLabel];

    [UIView setAnimationsEnabled:YES];
}

- (void)setSecondTitle:(NSString*)title
{
    [UIView setAnimationsEnabled:NO];

    self.secendLabel.text = title;
    [self arrangeLabel:self.secendLabel];

    [UIView setAnimationsEnabled:YES];
}

- (void)arrangeLabel:(UILabel*)label
{
    CGSize titleSize = [label.text sizeWithAttributes:@{
        NSFontAttributeName : self.mFont
    }];

    CGFloat titleWidth = titleSize.width;
    CGFloat imageWidth = 0;

    CGFloat titlePosX = round((self.bounds.size.width - titleWidth) / 2);

    CGFloat posY = round((self.segmentedControl.bounds.size.height - self.mFont.ascender - 5) / 2) + self.segmentedControl.mTitleEdgeInsets.top - self.segmentedControl.mTitleEdgeInsets.bottom;

    label.frame = CGRectMake(titlePosX + imageWidth,
        posY,
        titleWidth,
        titleSize.height);
}

- (void)activate
{
    [self setSelected:NO];
    self.firstLabel.alpha = 1;
}

- (void)deactivate
{
    [self setSelected:YES];
    self.firstLabel.alpha = 0;
}

@end
