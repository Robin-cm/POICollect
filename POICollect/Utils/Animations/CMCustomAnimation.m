//
//  CMCustomAnimation.m
//  POICollect
//
//  Created by 敏梵 on 15/6/22.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomAnimation.h"
#import "MainPOIListViewController.h"

@implementation CMCustomAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];

    CGRect startFrame = CGRectZero;
    if ([fromVC isKindOfClass:[MainPOIListViewController class]]) {
        MainPOIListViewController* fromMainVC = ((MainPOIListViewController*)fromVC);
        //        startFrame = [fromMainVC.addPOIBtn convertRect:fromMainVC.addPOIBtn.frame toView:fromMainVC.view];
        startFrame = CGRectMake(fromMainVC.addPOIBtn.frame.origin.x, fromMainVC.addPOIBtn.frame.origin.y + 64, fromMainVC.addPOIBtn.frame.size.width, fromMainVC.addPOIBtn.frame.size.height);
        [fromMainVC hideAddPoiBtnWithAnimate:YES];
    }

    toVC.view.frame = startFrame;
    toVC.view.alpha = 0;

    UIView* viewContainer = [transitionContext containerView];
    [viewContainer addSubview:toVC.view];

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
        delay:0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            toVC.view.alpha = 1;
            toVC.view.frame = finalFrame;
        }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
}

@end
