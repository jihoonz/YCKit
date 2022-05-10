//
//  YCCoverTransition.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCCoverTransition.h"

@implementation YCCoverTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.20f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (self.isPresenting)
    {
        [containerView addSubview:toVC.view];
        
        CGRect toFrame;
        
        switch (self.type) {
            case kYCCoverTransitionLeft:
            {
                toFrame = toVC.view.frame;
                toFrame.origin.x = -containerView.frame.size.width;
                [toVC.view setFrame:toFrame];
                toFrame.origin.x = 0;
                break;
            }
                
            case kYCCoverTransitionRight:
            {
                toFrame = toVC.view.frame;
                toFrame.origin.x = containerView.frame.size.width;
                [toVC.view setFrame:toFrame];
                toFrame.origin.x = 0;
                break;
            }
                
            case kYCCoverTransitionTop:
            {
                toFrame = toVC.view.frame;
                toFrame.origin.y = -containerView.frame.size.height;
                [toVC.view setFrame:toFrame];
                toFrame.origin.y = 0;
                break;
            }
                
            case kYCCoverTransitionBottom:
            default:
            {
                toFrame = toVC.view.frame;
                toFrame.origin.y = containerView.frame.size.height;
                [toVC.view setFrame:toFrame];
                toFrame.origin.y = 0;
                break;
            }
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:1.f
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [toVC.view setFrame:toFrame];
                         } completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {
        [containerView addSubview:fromVC.view];
        
        CGRect fromFrame = fromVC.view.frame;
        
        switch (self.type) {
            case kYCCoverTransitionLeft:
            {
                fromFrame.origin.x = -containerView.frame.size.width;
                break;
            }
                
            case kYCCoverTransitionRight:
            {
                fromFrame.origin.x = containerView.frame.size.width;
                break;
            }
                
            case kYCCoverTransitionTop:
            {
                fromFrame.origin.y = -containerView.frame.size.height;
                break;
            }
                
            case kYCCoverTransitionBottom:
            default:
            {
                fromFrame.origin.y = containerView.frame.size.height;
                break;
            }
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:1.f
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             [fromVC.view setFrame:fromFrame];
                         } completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                         }];
        
    }
}

@end
