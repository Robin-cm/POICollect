//
//  CMDropdownButtonArrowView.h
//  POICollect
//  箭头
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMDropdownButtonArrowView : NSObject

#pragma mark - 方法

+ (UIImage*)getArrowImageWithFrame:(CGRect)frame andWithBgcolor:(UIColor*)bgColor;

+ (UIImage*)getRightImageWithFrame:(CGRect)frame andWithBgcolor:(UIColor*)bgcolor;

@end
