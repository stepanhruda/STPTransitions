#import "STPSlideUpTransition.h"

@implementation STPSlideUpTransition

#pragma mark - STPTransition Overrides

- (NSTimeInterval)transitionDuration {
    return 0.3f;
}

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion {
    [containerView addSubview:toView];
    toView.transform =
    CGAffineTransformMakeTranslation(0.0f,
                                     (self.isReversed ? -1 : 1) * CGRectGetHeight(containerView.frame));

    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                         fromView.transform =
                         CGAffineTransformMakeTranslation(0.0f, (self.isReversed ? 1 : -1) * CGRectGetHeight(containerView.frame));
                     } completion:^(BOOL finished) {
                         [fromView removeFromSuperview];
                         fromView.transform = CGAffineTransformIdentity;
                         onCompletion(finished);
                     }];
}
@end
