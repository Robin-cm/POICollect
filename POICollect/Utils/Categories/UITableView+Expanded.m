//
//  UITableView+Expanded.m
//  POICollect
//  列表视图扩展类
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UITableView+Expanded.h"

@implementation UITableView (Expanded)

- (void)addRadiusforCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.f;

        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        }
        else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        }
        else if (indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }
        else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }

        layer.path = pathRef;
        CFRelease(pathRef);

        if (cell.backgroundColor) {
            layer.fillColor = cell.backgroundColor.CGColor;
        }
        else if (cell.backgroundView && cell.backgroundView.backgroundColor) {
            layer.fillColor = cell.backgroundView.backgroundColor.CGColor;
        }
        else {
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        }

        if (addLine == YES) {
            CALayer* lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / kScreen_Scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 2, bounds.size.height - lineHeight, bounds.size.width - 2, lineHeight);
            lineLayer.backgroundColor = self.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }

        UIView* lineView = [[UIView alloc] initWithFrame:bounds];
        [lineView.layer insertSublayer:layer atIndex:0];
        lineView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = lineView;
    }
}

- (void)addLineforPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLeftSpace:(CGFloat)leftSpace
{
    [self addLineForPlainCell:cell forRowAtIndexPath:indexPath withLineColor:[UIColor colorWithHexString:@"0x97C6E4"] withLeftSpace:leftSpace];
}

/**
 *  给一个CELL添加横线
 *
 *  @param cell      cell
 *  @param indexPath 序号
 *  @param lineColor 线条的颜色
 *  @param leftSpace 横线距离左边的长度
 */
- (void)addLineForPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLineColor:(UIColor*)lineColor withLeftSpace:(CGFloat)leftSpace
{
    [self addLineForPlainCell:cell forRowAtIndexPath:indexPath withLineColor:lineColor withSectionLineColor:nil withLeftSpace:leftSpace];
}

/**
 *  给一个CELL添加横线
 *
 *  @param cell             CELL
 *  @param indexPath        序号
 *  @param lineColor        横线的颜色
 *  @param sectionLineColor 头部的横线的颜色
 *  @param leftSpace        左边的空白
 */
- (void)addLineForPlainCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath withLineColor:(UIColor*)lineColor withSectionLineColor:(UIColor*)sectionLineColor withLeftSpace:(CGFloat)leftSpace
{
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    NSLog(@"cell的高度是: %f", cell.bounds.size.height);
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    CGPathAddRect(pathRef, nil, bounds);
    layer.path = pathRef;
    CFRelease(pathRef);

    if (cell.backgroundColor) {
        layer.fillColor = cell.backgroundColor.CGColor;
        cell.backgroundColor = [UIColor clearColor];
        //        layer.fillColor = [UIColor blackColor].CGColor;
    }
    else if (cell.backgroundView && cell.backgroundView.backgroundColor) {
        layer.fillColor = cell.backgroundView.backgroundColor.CGColor;
    }
    else {
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    }

    if (!lineColor) {
        lineColor = self.separatorColor;
    }

    if (!sectionLineColor) {
        sectionLineColor = self.separatorColor;
    }

    if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
        //只有一个cell。加上长线&下长线
        [self layer:layer addLineUp:YES andLong:YES andColor:sectionLineColor.CGColor andBounds:bounds withLeftSpace:0];
        [self layer:layer addLineUp:NO andLong:YES andColor:sectionLineColor.CGColor andBounds:bounds withLeftSpace:0];
    }
    else if (indexPath.row == 0) {
        //第一个cell。加上长线&下短线
        [self layer:layer addLineUp:YES andLong:YES andColor:sectionLineColor.CGColor andBounds:bounds withLeftSpace:0];
        [self layer:layer addLineUp:NO andLong:NO andColor:lineColor.CGColor andBounds:bounds withLeftSpace:leftSpace];
    }
    else if (indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
        //最后一个cell。加下长线
        [self layer:layer addLineUp:NO andLong:YES andColor:sectionLineColor.CGColor andBounds:bounds withLeftSpace:0];
    }
    else {
        //中间的cell。只加下短线
        [self layer:layer addLineUp:NO andLong:NO andColor:lineColor.CGColor andBounds:bounds withLeftSpace:leftSpace];
    }
    if (cell.backgroundView) {
        [cell.backgroundView.layer insertSublayer:layer atIndex:0];
    }
    else {
        UIView* testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        cell.backgroundView = testView;
    }
}

- (void)layer:(CALayer*)layer addLineUp:(BOOL)isUp andLong:(BOOL)isLong andColor:(CGColorRef)color andBounds:(CGRect)bounds withLeftSpace:(CGFloat)leftSpace
{

    CALayer* lineLayer = [[CALayer alloc] init];
    CGFloat lineHeight = (1.0f / [UIScreen mainScreen].scale);
    CGFloat left, top;
    if (isUp) {
        top = 0;
    }
    else {
        top = bounds.size.height - lineHeight;
    }

    if (isLong) {
        left = 0;
    }
    else {
        left = leftSpace;
    }
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + left, top, bounds.size.width - left, lineHeight);
    lineLayer.backgroundColor = color;
    [layer addSublayer:lineLayer];
}

@end
