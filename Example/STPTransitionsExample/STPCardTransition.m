//
//  STPCardTransition.m
//
//  Created by Kerry Knight on 2/8/14.
//  Based on Colin Eberhardt's VCTransitionsLibrary https://github.com/ColinEberhardt/VCTransitionsLibrary
//  Adapted for STPTransitions by Stepan Hruda

#import "STPCardTransition.h"

@implementation STPCardTransition

#pragma mark - STPTransition Overrides

- (NSTimeInterval)transitionDuration {
    return 1.0f;
}

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion {
 
    if (self.isReversed) {
        [self executeReverseAnimationFromView:fromView toView:toView inContainerView:containerView executeOnCompletion:^(BOOL finished) {
           onCompletion(finished);
        }];
    } else {
        [self executeForwardAnimationFromView:fromView toView:toView inContainerView:containerView executeOnCompletion:^(BOOL finished) {
            onCompletion(finished);
        }];
    }
}

- (void)executeForwardAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView executeOnCompletion:(void (^)(BOOL))onCompletion {
    
    // positions the to- view off the bottom of the sceen
    CGRect offScreenFrame = containerView.frame;
    offScreenFrame.origin.y = containerView.frame.size.height;
    toView.frame = offScreenFrame;
    
    [containerView insertSubview:toView aboveSubview:fromView];
    
    CATransform3D t1 = [self firstTransform];
    CATransform3D t2 = [self secondTransformWithView:fromView];
    
    [UIView animateKeyframesWithDuration:self.transitionDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        fromView.layer.transform = t1;
        // push the from- view to the back
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            fromView.layer.transform = CATransform3DIdentity;
            fromView.alpha = 0.6;
            fromView.layer.transform = t2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
            fromView.layer.transform = CATransform3DIdentity;
        }];
        
        // slide the to- view upwards with simulated spring animation by overshooting the final location in
        // the first keyframe
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
            toView.frame = CGRectOffset(containerView.frame, 0.0, -30.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
            toView.frame = containerView.frame;
        }];
        
    } completion:^(BOOL finished) {
        onCompletion(finished);
    }];
    
    
}

- (void)executeReverseAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView executeOnCompletion:(void (^)(BOOL))onCompletion{
    
    // positions the to- view behind the from- view
    toView.frame = containerView.frame;
    CATransform3D scale = CATransform3DIdentity;
    toView.layer.transform = CATransform3DScale(scale, 0.9, 0.9, 1);
    toView.alpha = 0.6;
    
    [containerView insertSubview:toView belowSubview:fromView];
    
    CGRect frameOffScreen = containerView.frame;
    frameOffScreen.origin.y = containerView.frame.size.height;
    
    CATransform3D t1 = [self firstTransform];
    
    [UIView animateKeyframesWithDuration:self.transitionDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view off the bottom of the screen
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
            fromView.frame = frameOffScreen;
        }];
        
        // animate the to- view into place
        [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
            toView.layer.transform = t1;
            toView.layer.transform = CATransform3DIdentity;
            toView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
            toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        onCompletion(finished);
    }];
}

- (CATransform3D)firstTransform {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
}

- (CATransform3D)secondTransformWithView:(UIView*)view {
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height * -0.08, 0);
    t2 = CATransform3DScale(t2, 0.9, 0.9, 1);
    return t2;
}

@end
