//
//  CMPageView.h
//  POICollect
//
//  Created by 敏梵 on 15/6/20.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPageView;

@protocol CMPageViewDelegate <UIScrollViewDelegate>

@optional
- (void)chagedOfpageview:(CMPageView*)pageview withCurrentIndex:(NSUInteger)index;

@end

@interface CMPageView : UIScrollView <UIScrollViewDelegate>

#pragma mark - 属性

@property (nonatomic, assign, readonly) NSUInteger viewsCount;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

@property (nonatomic, weak) id<CMPageViewDelegate> pageViewDelegate;

#pragma mark - 初始化方法

- (id)initPageViewWithViews:(NSArray*)views;

#pragma mark - 实例方法

- (void)setCurrentViewIndex:(NSUInteger)index withAnimation:(BOOL)animate;

@end
