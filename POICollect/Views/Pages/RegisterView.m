//
//  RegisterView.m
//  POICollect
//  注册页面
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        UILabel* label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = @"这个是注册页面";

        [label makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(self);
            make.left.equalTo(self.left).offset(0);
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
