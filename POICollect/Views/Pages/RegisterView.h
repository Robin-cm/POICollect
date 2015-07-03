//
//  RegisterView.h
//  POICollect
//
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//
#import "AIFNetworking.h"
@class LoginViewController;

static const NSString* sDefaultDoneNotifacitionidentifier = @"closeLoginModel";

@interface RegisterView : UIView <RTAPIManagerValidator, RTAPIManagerParamSourceDelegate, RTAPIManagerApiCallBackDelegate>

#pragma mark - parentViewController

- (instancetype)initWithParentViewController:(LoginViewController*)parentViewController;

@end
