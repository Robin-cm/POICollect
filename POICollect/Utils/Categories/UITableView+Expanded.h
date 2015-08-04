//
//  UITableView+Expanded.h
//  POICollect
//
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface UITableView (Expanded)

/**
 *  给一个cell添加圆角
 **/
- (void)addRadiusforCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 *  给一个cell添加横线
 **/
- (void)addLineforPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLeftSpace:(CGFloat)leftSpace;

/**
 *  给一个CELL添加横线
 *
 *  @param cell      cell
 *  @param indexPath 序号
 *  @param lineColor 线条的颜色
 *  @param leftSpace 横线距离左边的长度
 */
- (void)addLineForPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLineColor:(UIColor*)lineColor withLeftSpace:(CGFloat)leftSpace;

/**
 *  给一个CELL添加横线
 *
 *  @param cell             CELL
 *  @param indexPath        序号
 *  @param lineColor        横线的颜色
 *  @param sectionLineColor 头部的横线的颜色
 *  @param leftSpace        左边的空白
 */
- (void)addLineForPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLineColor:(UIColor*)lineColor withSectionLineColor:(UIColor*)sectionLineColor withLeftSpace:(CGFloat)leftSpace;

@end
