//
//  CMRoundSegmentControl.m
//  POICollect
//  自定义的圆角的分段容器
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CMRoundSegmentControl.h"
#import "CMRoundSegmentedThumb.h"

@interface CMRoundSegmentControl ()

@property (nonatomic, strong) CMRoundSegmentedThumb* mThumb;

@property (nonatomic, strong) NSMutableArray* mThumbRects;

/**
 *  圆角
 */
@property (nonatomic, readwrite, assign) CGFloat mCornerRadius;

/**
 *  当前选中的序号
 */
@property (nonatomic, readwrite) NSUInteger mSelectedSegmendIndex;

@property (nonatomic, readwrite) BOOL moved;

@property (nonatomic, readwrite) BOOL trackingThumb;

@property (nonatomic, readwrite) NSUInteger snapToIndex;

@property (nonatomic, readwrite) CGFloat dragOffset;

@property (nonatomic, readwrite) BOOL activated;

/**
 *  每一个的宽度 
 */
@property (nonatomic, readwrite) CGFloat mSegmentWidth;

/**
 *  高度
 */
@property (nonatomic, readwrite) CGFloat mThumbHeight;

@end

@implementation CMRoundSegmentControl

#pragma mark - 实例方法

/**
 *  初始化一个CMRoundSegmentControl
 *
 *  @param pTitles 标题的数组
 *
 *  @return CMRoundSegmentControl
 */
- (CMRoundSegmentControl*)initWithSectionTitles:(NSArray*)pTitles
{
    if (self = [super initWithFrame:CGRectZero]) {
        if (!pTitles || pTitles.count < 1) {
            @throw [NSException exceptionWithName:@"分组控件报错" reason:@"标题数不能为零" userInfo:nil];
            return nil;
        }
        self.mSectionTitles = pTitles;
        self.mThumbRects = [NSMutableArray arrayWithCapacity:[pTitles count]];

        self.backgroundColor = [UIColor clearColor];
        self.mBackgroundTintColor = kRoundSegmentControlDefaultPrimaryColor;
        self.mBorderTintColor = kRoundSegmentControlDefaultSecendColor;
        self.mThumbColor = kRoundSegmentControlDefaultSecendColor;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;

        self.mFont = [UIFont systemFontOfSize:kRoundSegmentControlDefaultFontSize];
        self.mTextColor = kRoundSegmentControlDefaultSecendColor;
        self.mSelectedTextColor = kRoundSegmentControlDefaultPrimaryColor;

        self.mTitleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        self.mThumbEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.mHeight = kRoundSegmentControlDefaultHeight;
        self.mCornerRadius = self.mHeight / 2.0f;

        self.mTouchTargetMargins = UIEdgeInsetsMake(0, 0, 0, 0);

        self.mSelectedSegmendIndex = 0;
        self.layer.shouldRasterize = YES;
    }
    return self;
}

/**
 *  设置当前选中的序号
 *
 *  @param pIndex 选中的序号
 */
- (void)setSelectedSegmentIndex:(NSUInteger)pIndex
{
    if (pIndex >= _mSectionTitles.count) {
        @throw [NSException exceptionWithName:@"setSelectedSegmentIndex错误" reason:@"超出范围" userInfo:nil];
        return;
    }
    if (_mSelectedSegmendIndex == pIndex) {
        return;
    }
    [self setSelectedSegmentIndex:pIndex animated:YES];
}

#pragma mark - Setter

- (void)setMBackgroundTintColor:(UIColor*)mBackgroundTintColor
{
    if (!mBackgroundTintColor) {
        return;
    }
    _mBackgroundTintColor = mBackgroundTintColor;
    [self setNeedsDisplay];
}

- (void)setMBorderTintColor:(UIColor*)mBorderTintColor
{
    if (!mBorderTintColor) {
        return;
    }
    _mBorderTintColor = mBorderTintColor;
    [self setNeedsDisplay];
}

- (void)setMThumbColor:(UIColor*)mThumbColor
{
    if (!mThumbColor) {
        return;
    }
    _mThumbColor = mThumbColor;
    if (_mThumb) {
        self.mThumb.mThumbBackgroundColor = _mThumbColor;
    }
}

- (void)setMFont:(UIFont*)mFont
{
    if (!mFont) {
        return;
    }
    _mFont = mFont;
    [self setNeedsDisplay];
    if (_mThumb) {
        self.mThumb.mFont = _mFont;
    }
}

- (void)setMTextColor:(UIColor*)mTextColor
{
    if (!mTextColor) {
        return;
    }
    _mTextColor = mTextColor;
    [self setNeedsDisplay];
}

- (void)setMSelectedTextColor:(UIColor*)mSelectedTextColor
{
    if (!mSelectedTextColor) {
        return;
    }
    _mSelectedTextColor = mSelectedTextColor;
    if (_mThumb) {
        self.mThumb.mThumbTintColor = _mSelectedTextColor;
    }
}

- (void)setMHeight:(CGFloat)mHeight
{
    if (!mHeight) {
        return;
    }
    _mHeight = mHeight;
    [self setNeedsDisplay];
}

#pragma mark - getter

- (CGFloat)mCornerRadius
{
    return self.mHeight / 2.0f;
}

- (CMRoundSegmentedThumb*)mThumb
{
    if (_mThumb == nil)
        _mThumb = [[CMRoundSegmentedThumb alloc] initWithFrame:CGRectZero];
    return _mThumb;
}

#pragma mark - 生命周期

- (void)willMoveToWindow:(UIWindow*)newWindow
{
    if (newWindow == nil)
        return; // control is being _removed_ from super view

    [self updateSectionRects];
}

- (void)sizeToFit
{
    self.frame = CGRectZero;
    [self updateSectionRects];
}

#pragma - maek 事件响应

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    return CGRectContainsPoint(CGRectMake(bounds.origin.x - self.mTouchTargetMargins.left,
                                   bounds.origin.y - self.mTouchTargetMargins.top,
                                   bounds.size.width + self.mTouchTargetMargins.left + self.mTouchTargetMargins.right,
                                   bounds.size.height + self.mTouchTargetMargins.bottom + self.mTouchTargetMargins.top),
        point);
}

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint cPos = [touch locationInView:self.mThumb];
    self.activated = NO;

    self.snapToIndex = MIN(floor(self.mThumb.center.x / self.mSegmentWidth), self.mSectionTitles.count - 1);

    if ([self.mThumb pointInside:cPos withEvent:event]) {
        self.trackingThumb = YES;
        [self.mThumb deactivate];
        self.dragOffset = (self.mThumb.frame.size.width / 2) - cPos.x;
    }

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    [super continueTrackingWithTouch:touch withEvent:event];

    CGPoint cPos = [touch locationInView:self];
    CGFloat newPos = cPos.x + self.dragOffset;
    CGFloat newMaxX = newPos + (CGRectGetWidth(self.mThumb.frame) / 2);
    CGFloat newMinX = newPos - (CGRectGetWidth(self.mThumb.frame) / 2);

    CGFloat buffer = 0.0; // to prevent the thumb from moving slightly too far
    CGFloat pMaxX = CGRectGetMaxX(self.bounds) - buffer;
    CGFloat pMinX = CGRectGetMinX(self.bounds) + buffer;

    if ((newMaxX > pMaxX || newMinX < pMinX) && self.trackingThumb) {
        self.snapToIndex = MIN(floor(self.mThumb.center.x / self.mSegmentWidth), self.mSectionTitles.count - 1);

        if (newMaxX - pMaxX > 10 || pMinX - newMinX > 10)
            self.moved = YES;

        [self snap:NO];
        [self crossFadeThumbContent];
    }
    else if (self.trackingThumb) {
        self.mThumb.center = CGPointMake(cPos.x + self.dragOffset, self.mThumb.center.y);
        self.moved = YES;
        [self crossFadeThumbContent];
    }

    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    [super endTrackingWithTouch:touch withEvent:event];

    CGPoint cPos = [touch locationInView:self];
    CGFloat posX = cPos.x;

    CGFloat pMaxX = CGRectGetMaxX(self.bounds);
    CGFloat pMinX = CGRectGetMinX(self.bounds); // 5 is for thumb shadow

    if (!self.moved && self.trackingThumb && [self.mSectionTitles count] == 2)
        [self toggle];
    else if (!self.activated && posX > pMinX && posX < pMaxX) {
        int potentialSnapToIndex = MIN(floor(cPos.x / self.mSegmentWidth), self.mSectionTitles.count - 1);
        self.snapToIndex = potentialSnapToIndex;
        [self snap:YES];
    }
    else {
        if (posX < pMinX)
            posX = pMinX;

        if (posX >= pMaxX)
            posX = pMaxX - 1;

        self.snapToIndex = MIN(floor(posX / self.mSegmentWidth), self.mSectionTitles.count - 1);
        [self snap:YES];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent*)event
{
    [super cancelTrackingWithEvent:event];

    if (self.trackingThumb)
        [self snap:NO];
}

#pragma mark - 自定义方法

- (void)crossFadeThumbContent
{
    float segmentOverlap = ((int)(self.mThumb.center.x * 10 / self.mSegmentWidth)) / 10.0f; // how far along are we dragging through the current segment
    int hoverIndex = floor(segmentOverlap); // the segment the touch is current hovering
    BOOL secondTitleOnLeft = (segmentOverlap - hoverIndex) < 0.5;

    if (secondTitleOnLeft && hoverIndex > 0) {
        self.mThumb.firstLabel.alpha = 0.5 + (segmentOverlap - hoverIndex);
        self.mThumb.secendLabel.alpha = 0.5 - (segmentOverlap - hoverIndex);
        [self setThumbSecondValuesForIndex:hoverIndex - 1];
    }
    else if (hoverIndex + 1 < self.mSectionTitles.count) {
        self.mThumb.firstLabel.alpha = 0.5 + (1 - (segmentOverlap - hoverIndex));
        self.mThumb.secendLabel.alpha = (segmentOverlap - hoverIndex) - 0.5;
        [self setThumbSecondValuesForIndex:hoverIndex + 1];
    }
    else {
        self.mThumb.secendLabel.alpha = 0.0;
        self.mThumb.firstLabel.alpha = 1.0;
    }
    [self setThumbValuesForIndex:hoverIndex];
}

- (void)setThumbValuesForIndex:(NSUInteger)index
{
    [self.mThumb setTitle:[self.mSectionTitles objectAtIndex:index]];
}

- (void)setThumbSecondValuesForIndex:(NSUInteger)index
{
    [self.mThumb setSecondTitle:[self.mSectionTitles objectAtIndex:index]];
}

- (void)toggle
{
    if (self.snapToIndex == 0)
        self.snapToIndex = 1;
    else
        self.snapToIndex = 0;
    [self snap:YES];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated
{
    _mSelectedSegmendIndex = index;

    if (self.superview) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];

        if (animated) {
            [self.mThumb deactivate];
            [UIView animateWithDuration:0.2
                delay:0
                options:UIViewAnimationOptionCurveEaseOut
                animations:^{
                    self.mThumb.frame = [[self.mThumbRects objectAtIndex:index] CGRectValue];
                    [self crossFadeThumbContent];
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [self activate];
                    }
                }];
        }

        else {
            self.mThumb.frame = [[self.mThumbRects objectAtIndex:index] CGRectValue];
            [self activate];
        }
    }
}

- (void)activate
{
    self.trackingThumb = self.moved = NO;

    [self setThumbValuesForIndex:self.mSelectedSegmendIndex];

    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.activated = YES;
                         [self.mThumb activate];
                     }
                     completion:NULL];
}

- (void)snap:(BOOL)animated
{

    [self.mThumb deactivate];
    self.mThumb.secendLabel.alpha = 0;

    int index;

    if (self.snapToIndex != -1)
        index = (int)self.snapToIndex;
    else
        index = MIN(floor(self.mThumb.center.x / self.mSegmentWidth), self.mSectionTitles.count - 1);

    [self setThumbValuesForIndex:index];

    if (self.mChangeHandler && self.snapToIndex != self.mSelectedSegmendIndex) {
        //        NSLog(@"改变了状态了！!!!!!!!");
        self.mChangeHandler(self.snapToIndex);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:didSelectIndex:)] && self.snapToIndex != self.mSelectedSegmendIndex) {
        [self.delegate segmentControl:self didSelectIndex:self.snapToIndex];
    }

    if (animated) {
        [self setSelectedSegmentIndex:index animated:YES];
    }
    else {
        self.mThumb.frame = [[self.mThumbRects objectAtIndex:index] CGRectValue];
    }
}

/**
 *  更新每个按钮的大小
 */
- (void)updateSectionRects
{
    int c = (int)self.mSectionTitles.count;
    [self calculateSegmentWidth];

    if (CGRectIsEmpty(self.frame)) {
        self.bounds = CGRectMake(0, 0, self.mSegmentWidth * c, self.mHeight);
    }
    else {
        self.mHeight = self.frame.size.height;
    }

    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }

    self.mThumbHeight = self.mHeight - (self.mThumbEdgeInset.top + self.mThumbEdgeInset.bottom);

    self.mThumbRects = [NSMutableArray new];
    for (int i = 0; i < self.mSectionTitles.count; i++) {
        CGRect thumbRect = CGRectMake(self.mSegmentWidth * i, 0, self.mSegmentWidth, self.mHeight);
        [self.mThumbRects addObject:[NSValue valueWithCGRect:thumbRect]];
    }

    self.mThumb.frame = [[self.mThumbRects objectAtIndex:self.mSelectedSegmendIndex] CGRectValue];
    [self insertSubview:self.mThumb atIndex:0];
    [self setThumbValuesForIndex:self.mSelectedSegmendIndex];
}

/**
 *  计算宽度
 */
- (void)calculateSegmentWidth
{
    if (CGRectIsEmpty(self.frame)) {
        self.mSegmentWidth = 0;
        int i = 0;
        for (NSString* titleStr in self.mSectionTitles) {
            CGFloat stringWidth = [titleStr sizeWithAttributes:@{ NSFontAttributeName : self.mFont }].width + (self.mTitleEdgeInsets.left + self.mTitleEdgeInsets.right + self.mThumbEdgeInset.left + self.mThumbEdgeInset.right);
            self.mSegmentWidth = MAX(stringWidth, self.mSegmentWidth);
            i++;
        }
        self.mSegmentWidth = ceil(self.mSegmentWidth / 2.0) * 2;
    }
    else {
        self.mSegmentWidth = round(self.frame.size.width / self.mSectionTitles.count);
    }
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{

    NSLog(@"大的容器呗重新绘画了一次！！！！！！！！！！！！！");

    CGRect insetRect = CGRectMake(0, 0, rect.size.width, rect.size.height);

    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:self.mCornerRadius];
    [self.mBackgroundTintColor setFill];
    [self.mBorderTintColor setStroke];
    [roundedRect setLineWidth:0.5f];
    [roundedRect fill];
    [roundedRect stroke];
    //    CGPathRelease(roundedRect.CGPath);
    [self.mTextColor set];

    int i = 0;
    for (NSString* titleString in self.mSectionTitles) {

        CGSize titleSize = [titleString sizeWithAttributes:@{ NSFontAttributeName : self.mFont }];
        CGFloat titleWidth = titleSize.width;
        CGFloat posY = round((CGRectGetHeight(rect) - self.mFont.ascender - 5) / 2) + self.mTitleEdgeInsets.top - self.mTitleEdgeInsets.bottom;
        CGFloat sectionOffset = round((self.mSegmentWidth - titleWidth) / 2);
        CGFloat titlePosX = (self.mSegmentWidth * i) + sectionOffset;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [titleString drawAtPoint:CGPointMake(titlePosX, posY)
                        forWidth:self.mSegmentWidth
                        withFont:self.mFont
                   lineBreakMode:UILineBreakModeTailTruncation];
#else
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        [titleString drawInRect:CGRectMake(titlePosX, posY, self.mSegmentWidth, CGFLOAT_MAX)
                 withAttributes:@{
                     NSFontAttributeName : self.mFont,
                     NSForegroundColorAttributeName : self.mTextColor,
                     NSParagraphStyleAttributeName : paragraphStyle
                 }];
#endif
        i++;
    }
    NSLog(@"大的容器呗执行完了一次！！！！！！！！！！！！！");
}

@end
