//
//  main.m
//  POICollect
//
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIViewController+Swizzle.h"

int main(int argc, char* argv[])
{
    @autoreleasepool
    {
        swizzleAllViewController();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
