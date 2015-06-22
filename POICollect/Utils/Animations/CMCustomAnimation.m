//
//  CMCustomAnimation.m
//  POICollect
//
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomAnimation.h"

@implementation CMCustomAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectZero;

    UIView* viewContainer = [transitionContext containerView];
    [viewContainer addSubview:toVC.view];

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
        delay:0
        usingSpringWithDamping:0.6
        initialSpringVelocity:1
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            toVC.view.frame = finalFrame;
        }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
}

@end
