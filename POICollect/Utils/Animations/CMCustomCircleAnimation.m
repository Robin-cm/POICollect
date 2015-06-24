//
//  CMCustomCircleAnimation.m
//  POICollect
//  圆形动画
//  Created by 常敏 on 15-6-24.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCustomCircleAnimation.h"

static const CGFloat sDefaultAnimationDuration = 0.4f;
static const CGFloat sDefaultMinimumCircleScale = 0.2;
static const CGFloat sDefaultMaximumCircleScale = 2.5;

#define kCMCustomCircleMaskAnimation @"kCMCustomCircleMaskAnimation"

@interface CMCustomCircleAnimation ()

@end

@implementation CMCustomCircleAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maximumCircleScale = sDefaultMaximumCircleScale;
        _minimumCircleScale = sDefaultMinimumCircleScale;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return sDefaultAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect bounds = toVC.view.bounds;
    CAShapeLayer* circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.frame = bounds;

    CGFloat radius = 0;
    CGPoint circleCenter = CGPointZero;

    if ([self.delegate respondsToSelector:@selector(circleCenter)]) {
        circleCenter = [self.delegate circleCenter];
    }
    else {
        circleCenter = CGPointMake(fromVC.view.frame.origin.x + CGRectGetMidX(fromVC.view.bounds), fromVC.view.frame.origin.y + CGRectGetMidY(fromVC.view.bounds));
    }

    if ([self.delegate respondsToSelector:@selector(circleStartingRadius)]) {
        radius = [self.delegate circleStartingRadius];
    }
    else {
        radius = MIN(fromVC.view.frame.size.width, fromVC.view.frame.size.height) / 2;
    }

    circleMaskLayer.position = circleCenter;
    CGRect circleBoundingRect = CGRectMake(circleCenter.x - radius, circleCenter.y - radius, 2.0 * radius, 2.0 * radius);
    circleMaskLayer.path = [UIBezierPath bezierPathWithOvalInRect:circleBoundingRect].CGPath;
    circleMaskLayer.bounds = circleBoundingRect;

    CABasicAnimation* circleMaskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    circleMaskAnimation.duration = [self transitionDuration:transitionContext];
    circleMaskAnimation.repeatCount = 1.0; // Animate only once
    circleMaskAnimation.removedOnCompletion = NO; // Remain after the animation

    [circleMaskAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34:.01:.69:1.37]];

    if (self.isPositiveAnimation) {
        //进入动画
        [circleMaskAnimation setFillMode:kCAFillModeForwards];

        // Animate from small to large
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:self.minimumCircleScale];
        circleMaskAnimation.toValue = [NSNumber numberWithFloat:self.maximumCircleScale];

        // Add to the view and start the animation
        [toVC.view.layer setMask:circleMaskLayer];
        toVC.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kCMCustomCircleMaskAnimation];
        if ([self.delegate respondsToSelector:@selector(stateChange:)]) {
            [self.delegate stateChange:YES];
        }
    }
    else {
        //退出动画
        [circleMaskAnimation setFillMode:kCAFillModeForwards];

        // Animate from large to small
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        circleMaskAnimation.toValue = [NSNumber numberWithFloat:self.minimumCircleScale];

        // Add to the view and start the animation
        [fromVC.view.layer setMask:circleMaskLayer];
        fromVC.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kCMCustomCircleMaskAnimation];
        if ([self.delegate respondsToSelector:@selector(stateChange:)]) {
            [self.delegate stateChange:NO];
        }
    }

    [super animateTransition:transitionContext];
}

@end
