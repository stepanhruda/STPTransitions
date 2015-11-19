#import "STPTransition.h"

#import "STPTransitionCenter.h"
#import "UIViewController+STPTransitions.h"

@interface STPTransition ()

@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

@end

@implementation STPTransition

#pragma mark - Object Lifecycle

- (void)dealloc {
    self.gestureRecognizer = nil;
}

#pragma mark - Public Interface

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Override -animateFromView:toView:inContainerView:executeOnCompletion: in your subclass."
                                 userInfo:nil];
}

- (BOOL)wasTriggeredInteractively {
    return self.gestureRecognizer.state != UIGestureRecognizerStatePossible;
}

- (void)setGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureRecognizer != gestureRecognizer) {
        [_gestureRecognizer removeTarget:self action:@selector(handleGestureRecognizer:)];
        _gestureRecognizer = gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(handleGestureRecognizer:)];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning Protocol Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.fromViewController = fromViewController;
    self.toViewController = toViewController;
    self.toViewController.view.frame = [transitionContext finalFrameForViewController:self.toViewController];
    UIView *containerView = [transitionContext containerView];

    void (^modalPresentationCompletionFix)(void);
    if (self.needsRotationFixForModals) {
        modalPresentationCompletionFix = [self fixModalPresentationForFromViewController:fromViewController
                                                                        toViewController:toViewController
                                                                       transitionContext:transitionContext];
    }

    [toViewController beginAppearanceTransition:YES animated:YES];
    [fromViewController beginAppearanceTransition:NO animated:YES];
    [self animateFromView:fromViewController.view
                   toView:toViewController.view
          inContainerView:containerView
      executeOnCompletion:
     ^(BOOL finished) {
         BOOL wasCanceled = [transitionContext transitionWasCancelled];
         if (finished) {
             void (^animationCompletionBlock)() = ^{
                 if (!wasCanceled) {
                     [self.gestureRecognizer.view removeGestureRecognizer:self.gestureRecognizer];
                     self.gestureRecognizer = nil;
                     [fromViewController.view removeFromSuperview];
                     [toViewController endAppearanceTransition];
                     [fromViewController endAppearanceTransition];
                 } else {
                     [toViewController.view removeFromSuperview];
                 }
                 [transitionContext completeTransition:!wasCanceled];
                 if (modalPresentationCompletionFix) {
                     modalPresentationCompletionFix();
                 }
             };
             if ([NSThread mainThread] == [NSThread currentThread]) {
                 animationCompletionBlock();
             } else {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                    animationCompletionBlock();
                 });
             }
         }
     }];
}


- (void)animationEnded:(BOOL)transitionCompleted {
    if (self.onCompletion) {
        self.onCompletion(self, transitionCompleted);
    }
}

#pragma mark - Internal Methods

- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.onGestureTriggered(self, recognizer);
    } else {
        CGFloat completion = MAX(self
        .completionPercentageForGestureRecognizerState(recognizer), 0);

        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [self updateInteractiveTransition:completion];
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (self.shouldCompleteTransitionOnGestureEnded(recognizer, completion)) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
            [self cancelInteractiveTransition];
        }
    }
}

- (void (^)(void))fixModalPresentationForFromViewController:(UIViewController *)fromViewController
                                           toViewController:(UIViewController *)toViewController
                                          transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    CGAffineTransform toFinalRotation = toViewController.view.transform;
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];

    if (!self.isReversed) {
        BOOL fixInterfaceOrientation = fromViewController.fixInterfaceOrientationRotation;

        if (!fromViewController.presentingViewController) {
            containerView.transform = fromViewController.view.transform;
            containerView.frame = UIApplication.sharedApplication.delegate.window.bounds;

            fromViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.frame = containerView.bounds;

            fixInterfaceOrientation = YES;
        }

        toViewController.fixInterfaceOrientationRotation = fixInterfaceOrientation;
    }

    toViewController.view.transform = CGAffineTransformIdentity;
    toViewController.view.frame = containerView.bounds;

    void (^completionFix)(void);
    if (self.isReversed) {
        if (!toViewController.presentingViewController) {
            completionFix = ^{
                toViewController.view.transform = toFinalRotation;
                toViewController.view.frame = toFinalFrame;
            };
        } else {
            completionFix = ^{
                CGFloat angle = atan2(containerView.transform.b, containerView.transform.a);
                toViewController.view.superview.transform = CGAffineTransformRotate(toViewController.view.superview.transform, angle);
            };
        }
    }

    return completionFix;
}

@end
