//
//  AIFRequestGenerator.h
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@interface AIFRequestGenerator : NSObject

#pragma mark - 类方法

+ (instancetype)sharedInstance;

#pragma mark - 实例方法

- (NSURLRequest*)generateGETRequestWithServiceIdentifier:(NSString*)serviceIdentifier requestParams:(NSDictionary*)requestParams methodName:(NSString*)methodName;

- (NSURLRequest*)generatePOSTRequestWithServiceIdentifier:(NSString*)serviceIdentifier requestParams:(NSDictionary*)requestParams methodName:(NSString*)methodName;

- (NSURLRequest*)generatePOSTUploadRequestWithServiceIdentifier:(NSString*)serviceIdentifier requestParams:(NSDictionary*)requestParams methodName:(NSString*)methodName constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;

@end
