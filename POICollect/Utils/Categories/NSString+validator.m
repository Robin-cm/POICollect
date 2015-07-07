//
//  NSString+validator.m
//  POICollect
//  字符串验证
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "NSString+validator.h"

@implementation NSString (validator)

#pragma mark - 实例方法

/**
 *  是不是为空
 *
 *  @return
 */
- (BOOL)isBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}

@end
