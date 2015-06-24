//
//  CMCustomCircleAnimation.h
//  POICollect
//  圆形动画
//  Created by 常敏 on 15-6-24.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomBaseAnimation.h"

@protocol CMCustomCircleAnimationProtocol <NSObject>

@optional

- (CGPoint)circleCenter;

- (CGFloat)circleStartingRadius;

- (void)stateChange:(BOOL)isOpen;

@end

@interface CMCustomCircleAnimation : CMCustomBaseAnimation <CMCustomBaseAnimationProtocol>

@property (nonatomic, weak) id<CMCustomCircleAnimationProtocol> delegate;

@property (nonatomic, assign) CGFloat maximumCircleScale;
@property (nonatomic, assign) CGFloat minimumCircleScale;

@end
