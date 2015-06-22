//
//  CMPageView.m
//  POICollect
//  翻页组件
//  Created by 敏梵 on 15/6/20.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPageView.h"

@interface CMPageView ()

@property (nonatomic, assign, readwrite) NSUInteger viewsCount;

@property (nonatomic, assign, readwrite) NSUInteger currentIndex;

@property (nonatomic, strong) NSArray* views;

@end

@implementation CMPageView

#pragma mark - 初始化方法

- (id)initPageViewWithViews:(NSArray*)views
{
    self = [super init];
    if (self) {
        [self configScrollView];
        [self configSubViews:views];
    }
    return self;
}

#pragma mark - 生命周期

- (void)didMoveToSuperview
{
}

- (void)layoutSubviews
{
    self.contentSize = CGSizeMake(_viewsCount * CGRectGetWidth(self.bounds), 0);

    for (UIView* view in _views) {
        [self addSubview:view];
    }

    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < _viewsCount; i++) {
        UIView* view = [_views objectAtIndex:i];
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.top).offset(0);
            make.bottom.equalTo(weakSelf.bottom).offset(0);
            make.width.equalTo(weakSelf.width);
            make.height.equalTo(weakSelf.height);
            make.left.equalTo(i == 0 ? weakSelf.left : ((UIView*)[_views objectAtIndex:(i - 1)]).right).offset(0);
            make.right.equalTo(i == (_views.count) - 1 ? weakSelf.right : ((UIView*)[_views objectAtIndex:(i + 1)]).left).offset(0);
        }];
    }
}

#pragma mark - 实例公共方法

- (void)setCurrentViewIndex:(NSUInteger)index withAnimation:(BOOL)animate
{
    if (index >= _viewsCount) {
        @throw [NSException exceptionWithName:@"setCurrentViewIndex错误" reason:@"超出范围" userInfo:nil];
        return;
    }
    if (index == _currentIndex) {
        return;
    }
    _currentIndex = index;
    CGRect toFrame = ((UIView*)[_views objectAtIndex:_currentIndex]).frame;
    NSLog(@"Frame------ %f", toFrame.origin.x);
    [self setContentOffset:CGPointMake(toFrame.origin.x, 0) animated:animate];
}

#pragma mark - 实例私有方法

- (void)configScrollView
{
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
}

- (void)configSubViews:(NSArray*)pViews
{
    if (!pViews || [pViews count] < 1) {
        @throw [NSException exceptionWithName:@"初始化pageView错误！" reason:@"传入的VIEW不能为空" userInfo:nil];
        return;
    }
    _views = pViews;
    _viewsCount = _views.count;
    _currentIndex = 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSLog(@"————————————————————————");
    int cIndex = floor((fabs(self.contentOffset.x) / CGRectGetWidth(self.bounds)));
    NSLog(@"当前是第 %i 页", cIndex);
    if (_currentIndex != cIndex) {
        _currentIndex = cIndex;
        if ([_pageViewDelegate respondsToSelector:@selector(chagedOfpageview:withCurrentIndex:)]) {
            [_pageViewDelegate chagedOfpageview:self withCurrentIndex:_currentIndex];
        }
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
