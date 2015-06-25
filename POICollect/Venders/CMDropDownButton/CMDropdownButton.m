//
//  CMDropdownButton.m
//  POICollect
//  下拉菜单
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMDropdownButton.h"

@interface CMDropdownButton ()

@end

@implementation CMDropdownButton

#pragma mark - 方法

- (id)initDropdownButtonWithTitle:(NSString*)title
{
    return [self initDropdownButtonWithTitle:title andWithDatas:nil];
}

- (id)initDropdownButtonWithTitle:(NSString*)title andWithDatas:(NSArray*)datas
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 自定义方法

- (void)configView
{
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
