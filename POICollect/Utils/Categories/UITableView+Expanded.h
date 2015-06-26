//
//  UITableView+Expanded.h
//  POICollect
//
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (Expanded)

/**
 *  给一个cell添加圆角
 **/
- (void)addRadiusforCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 *  给一个cell添加圆角,左边的间距
 **/
- (void)addLineforPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLeftSpace:(CGFloat)leftSpace;

@end
