//
//  CMDropdownButton.h
//  POICollect
//  下拉菜单
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMDropdownButton : UIButton

#pragma mark - 属性

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSArray* datas;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIImage* arrowImage;

#pragma mark - 方法

- (id)initDropdownButtonWithTitle:(NSString*)title;

- (id)initDropdownButtonWithTitle:(NSString*)title andWithDatas:(NSArray*)datas;

@end
