//
//  UIViewController+Swizzle.h
//  POICollect
//
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface UIViewController (Swizzle)

/**
 *  自定义的ViewDidLoad 方法
 */
- (void)customViewDidLoad;

@end

/**
 *  交换所有的ViewController的一些方法
 */
void swizzleAllViewController();
