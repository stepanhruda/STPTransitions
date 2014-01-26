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
//    return (1.3f * point.x) / [UIScreen mainScreen].applicationFrame.size.width;
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
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [self animateFromView:fromVC.view
                   toView:toVC.view
          inContainerView:container
      executeOnCompletion:^(BOOL finished) { [transitionContext completeTransition:finished]; }];
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

@end
