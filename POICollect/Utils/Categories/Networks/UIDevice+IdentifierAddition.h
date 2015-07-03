//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (IdentifierAddition)

/*
 * @method uuid
 * @description apple identifier support iOS6 and iOS5 below
 */

- (NSString*)AIF_uuid;
//- (NSString*)AIF_udid;
- (NSString*)AIF_macaddress;
- (NSString*)AIF_macaddressMD5;
- (NSString*)AIF_machineType;
- (NSString*)AIF_ostype; //显示“ios6，ios5”，只显示大版本号
- (NSString*)AIF_createUUID;

//兼容旧版本
- (NSString*)uuid;
//- (NSString*)udid;
- (NSString*)macaddress;
- (NSString*)macaddressMD5;
- (NSString*)machineType;
- (NSString*)ostype; //显示“ios6，ios5”，只显示大版本号
- (NSString*)createUUID;

/**
 *  对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就
 *  不一致。
 **/
+ (NSString*)identifierForVendor;

@end
