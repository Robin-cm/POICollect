//
//  AIFCachedObject.h
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface AIFCachedObject : NSObject

@property (nonatomic, copy, readonly) NSData* content;

@property (nonatomic, copy, readonly) NSDate* lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;

@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData*)content;

- (void)updateContent:(NSData*)content;

@end
