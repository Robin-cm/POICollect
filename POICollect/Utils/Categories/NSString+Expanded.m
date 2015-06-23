//
//  NSString+Expanded.m
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "NSString+Expanded.h"

@implementation NSString (Expanded)

- (CGSize)getSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : font } context:nil].size;
    }
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}

- (CGFloat)getWidthWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

@end
