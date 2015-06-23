//
//  NSString+Expanded.h
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface NSString (Expanded)

#pragma mark - 实例方法

- (CGSize)getSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

- (CGFloat)getHeightWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

- (CGFloat)getWidthWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

@end
