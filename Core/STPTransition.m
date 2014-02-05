#import "STPTransition.h"

#import "STPTransitionCenter.h"

@implementation STPTransition

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _minimumGestureCompletionPercentageRequiredToFinish = 0.4f;
    }
    return self;
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

- (void)gestureDidBegin {}

- (CGFloat)completionPercentageForGestureAtPoint:(CGPoint)point {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"If your transition is interactive, override -completionPercentageForGestureAtPoint:."
                                 userInfo:nil];
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
         if (finished) {
             [toViewController endAppearanceTransition];
             [fromViewController endAppearanceTransition];
         }
         BOOL transitionWasCanceled = [transitionContext transitionWasCancelled];
         dispatch_async(dispatch_get_main_queue(), ^{
             [transitionContext completeTransition:!transitionWasCanceled];
             if (modalPresentationCompletionFix) {
                 modalPresentationCompletionFix();
             }
         });
     }];
}


- (void)animationEnded:(BOOL)transitionCompleted {
    if (self.onCompletion) {
        self.onCompletion(transitionCompleted);
    }
}

#pragma mark - Internal Methods

- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (!self.isInteractive) {
            self.gestureRecognizer = nil;
        }
        [self gestureDidBegin];
    } else {
        CGPoint locationInView = [recognizer locationInView:recognizer.view];
        CGFloat completion = [self completionPercentageForGestureAtPoint:locationInView];

        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [self updateInteractiveTransition:completion];
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (completion >= self.minimumGestureCompletionPercentageRequiredToFinish) {
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
    CGRect fromInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGFloat yOffset = - (CGRectGetMaxY(fromInitialFrame));
    CGRect fromFinalFrame = CGRectOffset(fromInitialFrame, 0.0, yOffset);

    CGAffineTransform toFinalRotation = toViewController.view.transform;
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];

    if (!self.isReversed && !fromViewController.presentingViewController) {
        containerView.transform = fromViewController.view.transform;
        containerView.frame = UIApplication.sharedApplication.delegate.window.bounds;

        fromViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.frame = containerView.bounds;
    }

    toViewController.view.transform = CGAffineTransformIdentity;
    toViewController.view.frame = containerView.bounds;

    void (^completionFix)(void);
    if (self.isReversed && !toViewController.presentingViewController) {
        completionFix = ^{
            toViewController.view.transform = toFinalRotation;
            toViewController.view.frame = toFinalFrame;
        };
    }

    return completionFix;
}

@end
