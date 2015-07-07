//
//  RegistUser.m
//  POICollect
//  注册
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//
#import "NSString+validator.h"
#import "RegistUser.h"

@implementation RegistUser

- (NSString*)validateForm
{
    NSString* errorStr = @"";
    if ([_registName isBlankString]) {
        errorStr = @"用户名不能为空";
        return errorStr;
    }
    if ([_registPass isBlankString]) {
        errorStr = @"密码不能为空";
        return errorStr;
    }
    if ([_registConformPass isBlankString]) {
        errorStr = @"确认密码不能为空";
        return errorStr;
    }
    if (![_registPass isEqualToString:_registConformPass]) {
        errorStr = @"两次密码不一致";
        return errorStr;
    }
    if (_registPass.length < 6) {
        errorStr = @"密码的长度不能小于6位";
        return errorStr;
    }
    return errorStr;
}

@end
