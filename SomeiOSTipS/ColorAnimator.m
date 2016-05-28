//
//  ColorAnimator.m
//  SomeiOSTipS
//
//  Created by tunsuy on 10/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ColorAnimator.h"

#define kTransitionDuration 0.5
#define kSpring 0.5
#define kSpringVelocity 0.2

@interface ColorAnimator ()

@end

@implementation ColorAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *viewForAnimation = self.presenting ? toView : fromView;
    UIView *originViewAnimation = self.presenting ? fromVC.view : toVC.view;
    UIViewController *animationVC = self.presenting ? toVC : fromVC;
    
    CGFloat initViewHeight = [transitionContext finalFrameForViewController:animationVC].size.height;
    CGRect initViewFrame = CGRectMake(0, containerView.frame.size.height, containerView.frame.size.width, initViewHeight);
    
    if (self.presenting) {
        viewForAnimation.frame = initViewFrame;
        [containerView addSubview:viewForAnimation];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:kSpring
          initialSpringVelocity:kSpringVelocity
                        options:UIViewAnimationOptionTransitionCurlUp animations:^(){
                            if (self.presenting) {
                                viewForAnimation.frame = [transitionContext finalFrameForViewController:animationVC];
                                CGRect frame = originViewAnimation.frame;
                                frame.origin.y -= viewForAnimation.bounds.size.height;
                                originViewAnimation.frame = frame;
                            }
                            else {
                                viewForAnimation.frame = initViewFrame;
                                CGPoint point = originViewAnimation.center;
                                point.y += viewForAnimation.bounds.size.height;
                                originViewAnimation.center = point;
                            }
                        }
                     completion:^(BOOL finished){
                         if (!self.presenting) {
                             [viewForAnimation removeFromSuperview];
                         }
                         [transitionContext completeTransition:true];
                     }];
}

@end
