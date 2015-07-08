//
//  NSString+validator.h
//  POICollect
//
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (validator)

#pragma mark - 实例方法

/**
 *  是不是为空
 *
 *  @return 
 */
- (BOOL)isBlankString;


+ (NSString*)stringFromNumber:(NSNumber*)number;

@end
