//
//  LoginView.m
//  POICollect
//  登录页面
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        UILabel* label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = @"这个是登录页面";

        [label makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(self);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
