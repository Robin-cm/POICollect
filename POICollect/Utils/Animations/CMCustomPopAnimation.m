//
//  CMCustomPopAnimation.m
//  POICollect
//
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomPopAnimation.h"
#import "MainPOIListViewController.h"

@implementation CMCustomPopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView* viewContainer = [transitionContext containerView];
    [viewContainer addSubview:toVC.view];
    [viewContainer addSubview:fromVC.view];

    CGRect endRect = CGRectZero;
    if ([toVC isKindOfClass:[MainPOIListViewController class]]) {
        MainPOIListViewController* toMainVC = (MainPOIListViewController*)toVC;
        CGRect tmpRect = toMainVC.addPOIBtn.frame;
        endRect = CGRectMake(tmpRect.origin.x, tmpRect.origin.y + 64, tmpRect.size.width, tmpRect.size.height);
        [toMainVC showAddPoiBtnWithAnimate:YES];
    }

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            fromVC.view.alpha = 0;
            fromVC.view.frame = endRect;
        }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
}

@end
