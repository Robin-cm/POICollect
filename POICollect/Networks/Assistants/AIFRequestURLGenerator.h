//
//  AIFRequestURLGenerator.h
//  POICollect
//
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface AIFRequestURLGenerator : NSObject

#pragma mark - 类方法

+ (instancetype)sharedInstance;

- (NSString*)generateUploadRequestURLWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName;

@end
