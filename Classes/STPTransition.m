
#import "STPTransition.h"

#import "STPTransitionCenter.h"
#import "STPViewTransitionAnimation.h"

@interface STPTransition ()

@property (nonatomic, copy) void (^animateAdHocInContext)(id<UIViewControllerContextTransitioning>);

@end

@implementation STPTransition


#pragma mark - Public Interface

+ (instancetype)transitionWithAnimation:(void (^)(id<UIViewControllerContextTransitioning>))animateAdHoc {
    STPTransition *transition = [self new];
    transition.animateAdHocInContext = animateAdHoc;
    return transition;
}

- (CGFloat)completionForGesturePoint:(CGPoint)point {
    return (1.3f * point.x) / [UIScreen mainScreen].applicationFrame.size.width;
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
};

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.animateAdHocInContext) {
        self.animateAdHocInContext(transitionContext);
    } else if (self.viewTransitionAnimationClass) {

        UIView *container = [transitionContext containerView];

        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];


        [self.viewTransitionAnimationClass transitionFromView:fromVC.view
                                                       toView:toVC.view
                                                 asSubviewsOf:container
                                        usingReverseAnimation:self.reverse
                                                 onCompletion:^(BOOL finished){
                                                     [transitionContext completeTransition:finished];
                                                 }];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted {
    if (self.onAnimationEnded) {
        self.onAnimationEnded(transitionCompleted);
    }
}


#pragma mark - Internal Methods

- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (!self.isInteractive) {
            self.gestureRecognizer = nil;
        }
        self.onGestureTriggered();
    } else if (self.onInteractiveGestureChanged) {
        self.onInteractiveGestureChanged(recognizer);
    } else {
        CGPoint locationInView = [recognizer locationInView:recognizer.view];
        CGFloat completion;
        if (self.gestureCompletionForPoint) {
            completion = self.gestureCompletionForPoint(locationInView);
        } else {
            completion = [self completionForGesturePoint:locationInView];
        }

        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [self updateInteractiveTransition:completion];
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (completion > 0.4f) {
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
