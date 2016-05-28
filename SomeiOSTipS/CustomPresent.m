//
//  CustomPresent.m
//  SomeiOSTipS
//
//  Created by tunsuy on 10/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "CustomPresent.h"

@interface CustomPresent ()

@property (nonatomic, strong) UIView *dimingView;

@end

@implementation CustomPresent

- (CGRect)frameOfPresentedViewInContainerView {
    CGFloat xOffset = 0;
    CGFloat yOffset = 2 * self.containerView.bounds.size.height / 3;
    CGFloat viewWidth = self.containerView.bounds.size.width;
    CGFloat viewHeight = self.containerView.bounds.size.height / 3;
    return CGRectMake(xOffset, yOffset, viewWidth, viewHeight);
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        _dimingView = [[UIView alloc] init];
        _dimingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _dimingView.alpha = 0;
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    UIView *containerView = self.containerView;
    self.dimingView.frame = containerView.bounds;
    self.dimingView.alpha = 0;
    
    [containerView addSubview:self.dimingView];
    
    [[self.presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                                                            self.dimingView.alpha = 1.0;
                                                                            }
                                                                          completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.dimingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [[self.presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                                                            self.dimingView.alpha = 0;
                                                                            }
                                                                          completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimingView removeFromSuperview];
    }
}

@end
