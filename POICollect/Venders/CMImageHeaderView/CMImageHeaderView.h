//
//  CMImageHeaderView.h
//  POICollect
//
//  Created by 常敏 on 15/7/13.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface CMImageHeaderView : UIView

#pragma mark - 属性

@property (nonatomic) UILabel* headerTitleLabel;

@property (nonatomic) UIImage* headerImage;

#pragma mark - 公共静态方法

+ (id)cmImageHeaderViewWithImage:(UIImage*)image forSize:(CGSize)headerSize;

+ (id)cmImageHeaderViewWithSubView:(UIView*)subView;

#pragma mark - 公共实例方法

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

- (void)refreshBlurViewForNewImage;

@end
