//
//  UIview+CMExpened.m
//  POICollect
//  视图的扩展类
//  Created by 敏梵 on 15/6/20.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UIView+CMExpened.h"

@implementation UIView (CMExpened)

- (void)borderWithColor:(UIColor*)borderColor andWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
