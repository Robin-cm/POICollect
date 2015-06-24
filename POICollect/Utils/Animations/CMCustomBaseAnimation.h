//
//  CMCustomBaseAnimation.h
//  POICollect
//  动画的基类
//  Created by 常敏 on 15-6-24.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@protocol CMCustomBaseAnimationProtocol <UIViewControllerAnimatedTransitioning>

@required
/**
 * If the animation should be positive or negative.
 * Positive: push / present / fromTop / toRight
 * Negative: pop / dismiss / fromBottom / toLeft
 */
@property (nonatomic, assign) BOOL isPositiveAnimation;

@end

@interface CMCustomBaseAnimation : NSObject <CMCustomBaseAnimationProtocol>

@end
