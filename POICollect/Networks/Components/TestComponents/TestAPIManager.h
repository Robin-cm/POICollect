//
//  TestAPIManager.h
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface TestAPIManager : RTAPIBaseManager <RTAPIManager, RTAPIManagerValidator, RTAPIManagerParamSourceDelegate, RTAPIManagerApiCallBackDelegate>

#pragma mark - 方法

+ (instancetype)sharedInstance;

@end
