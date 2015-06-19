//
//  CMRoundSegmentControl.h
//  POICollect
//  自定义的圆角的分段容器
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

#define kRoundSegmentControlDefaultPrimaryColor [UIColor colorWithHexString:@"0x0076AB"]
#define kRoundSegmentControlDefaultSecendColor [UIColor colorWithHexString:@"0xD0E3EF"]

#define kRoundSegmentControlDefaultHeight 30.0f
#define kRoundSegmentControlDefaultFontSize 15.f

@class CMRoundSegmentControl;
@class CMRoundSegmentedThumb;

@protocol CMRoundSegmentControlDelegate <NSObject>

/**
 *  选中时调用的回调
 *
 *  @param pSegmentControl 当前的segmentControl
 *  @param pIndex          选中的序号
 */
- (void)segmentControl:(CMRoundSegmentControl*)pSegmentControl didSelectIndex:(NSUInteger)pIndex;

@end

@interface CMRoundSegmentControl : UIControl

@property (nonatomic, weak) id<CMRoundSegmentControlDelegate> delegate;

/**
 *  改变选中的Block回调函数
 */
@property (nonatomic, copy) void (^mChangeHandler)(NSUInteger newIndex);

/**
 *  所有的标题的数组
 */
@property (nonatomic, copy) NSArray* mSectionTitles;

/**
 *  当前选中的序号 
 */
@property (nonatomic, readonly) NSUInteger mSelectedSegmendIndex;

/**
 *  交互边界
 */
@property (nonatomic, readwrite) UIEdgeInsets mTouchTargetMargins;

/**
 *  背景颜色
 */
@property (nonatomic, strong) UIColor* mBackgroundTintColor;

/**
 *  边线和选中按钮的颜色
 */
@property (nonatomic, strong) UIColor* mBorderTintColor;

/**
 *  移动的块儿的颜色
 */
@property (nonatomic, strong) UIColor* mThumbColor;

/**
 *  当前的高度
 */
@property (nonatomic, readwrite, assign) CGFloat mHeight;

/**
 *  内边界，default is UIEdgeInsetsMake(2, 2, 3, 2)
 */
@property (nonatomic, readwrite) UIEdgeInsets mThumbEdgeInset;

/**
 *  default is UIEdgeInsetsMake(0, 10, 0, 10)
 */
@property (nonatomic, readwrite) UIEdgeInsets mTitleEdgeInsets;

/**
 *  圆角
 */
@property (nonatomic, readonly, assign) CGFloat mCornerRadius;

/**
 *  字体、default is [UIFont boldSystemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont* mFont;

/**
 *  文字的颜色、default is [UIColor grayColor];
 */
@property (nonatomic, strong) UIColor* mTextColor;

/**
 *  选中的文字的颜色
 */
@property (nonatomic, strong) UIColor* mSelectedTextColor;

@property (nonatomic, strong, readonly) CMRoundSegmentedThumb* mThumb;

#pragma mark - 实例方法

/**
 *  初始化一个CMRoundSegmentControl
 *
 *  @param pTitles 标题的数组
 *
 *  @return CMRoundSegmentControl
 */
- (CMRoundSegmentControl*)initWithSectionTitles:(NSArray*)pTitles;

/**
 *  设置当前选中的序号
 *
 *  @param pIndex 选中的序号
 */
- (void)setSelectedSegmentIndex:(NSUInteger)pIndex;

@end
