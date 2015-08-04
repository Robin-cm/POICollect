//
//  UIButton+Bootstrap.h
//  POICollect
//
//  Created by 常敏 on 15/7/16.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "NSString+FontAwesome.h"

@interface UIButton (Bootstrap)

#pragma mark - 实例方法

/**
 *  添加图标
 *
 *  @param icon   图标
 *  @param before 是否在标题之前
 */
- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;

/**
 *  bootstrap样式
 */
- (void)bootstrapStyle;

/**
 *  默认样式
 */
- (void)defaultStyle;

/**
 *  primary样式
 */
- (void)primaryStyle;

/**
 *  success样式
 */
- (void)successStyle;

/**
 *  info样式
 */
- (void)infoStyle;

/**
 *  warning样式
 */
- (void)warningStyle;

/**
 *  danger样式
 */
- (void)dangerStyle;

@end
