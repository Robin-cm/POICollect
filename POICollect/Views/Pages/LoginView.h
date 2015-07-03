//
//  LoginView.h
//  POICollect
//
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//
#import "AIFNetworking.h"
@class LoginViewController;

#define kDefaultDoneNotifacitionidentifier @"closeLoginModel"

@interface LoginView : UIView <RTAPIManagerValidator, RTAPIManagerParamSourceDelegate, RTAPIManagerApiCallBackDelegate>

#pragma mark - 方法

- (instancetype)initWithParentViewController:(LoginViewController*)parentViewController;

@end
