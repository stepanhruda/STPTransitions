#import "STPRotateFadeTransition.h"

@implementation STPRotateFadeTransition

- (NSTimeInterval)transitionDuration {
    return 0.5f;
}

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion {
    toView.alpha = 0.0f;

    CGFloat offsetX = CGRectGetWidth(containerView.bounds) / 2.5f;

    toView.layer.transform = !self.isReversed ? [self rotatedRightToX:offsetX] : [self rotatedLeftToX:offsetX];

    [containerView addSubview:toView];

    [UIView animateWithDuration:self.transitionDuration
                     animations:
     ^{
         fromView.alpha = 0.0f;
         toView.alpha = 1.0f;

         fromView.layer.transform = !self.isReversed ? [self rotatedLeftToX:offsetX] : [self rotatedRightToX:offsetX];
         toView.layer.transform = CATransform3DIdentity;
     }
                     completion:
     ^(BOOL finished) {
         onCompletion(finished);

         fromView.alpha = 1.0f;
         toView.alpha = 1.0f;

         fromView.layer.transform = CATransform3DIdentity;
         toView.layer.transform = CATransform3DIdentity;
     }];
}

- (CATransform3D)rotatedLeftToX:(CGFloat)offsetX {
    CATransform3D rotateNegatively = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
    CATransform3D moveLeft = CATransform3DMakeTranslation(-offsetX, 0, 0);
    return CATransform3DConcat(rotateNegatively, moveLeft);
}

- (CATransform3D)rotatedRightToX:(CGFloat)offsetX {
    CATransform3D rotatePositively = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    CATransform3D moveRight = CATransform3DMakeTranslation(offsetX, 0, 0);
    return CATransform3DConcat(rotatePositively, moveRight);
}

@end
