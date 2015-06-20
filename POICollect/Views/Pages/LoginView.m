//
//  LoginView.m
//  POICollect
//  登录页面
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginView.h"
#import "UIView+CMExpened.h"

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews
{
    UILabel* label = [[UILabel alloc] init];
    [self addSubview:label];
    [label borderWithColor:[UIColor blackColor] andWidth:1];
    label.text = @"这个是登录页面";
    //    label.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));

    [label makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@40);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
