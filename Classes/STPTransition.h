@import UIKit;

@interface STPTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

// Common method to override in any subclass
// You're responsible for executing the completion block after animation is finished.
- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
           onCompletion:(void (^)(BOOL))onCompletion;

// Assign your animation's duration here.
// Duration is used for other views to synchronize their animations, e.g. the navigation bar.
@property (nonatomic, assign) NSTimeInterval transitionDuration;

// Transition's completion block
@property (nonatomic, copy) void (^onCompletion)(BOOL transitionCompleted);

// Gets assigned YES when popping or dismissing a view controller.
// You can take advantage of this property to implement both ways of a transition in one class.
@property (nonatomic, assign, getter = isReversed) BOOL reversed;

// Gesture recognizer to trigger the transition via a gesture
// It can, but does _not_ have to make the transition interactive.
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

// Assign YES, if the transition can be interactive.
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

// Returns YES if the transition was kicked off interactively using the recognizer.
// Even interactive transition can happen non-interactively (e.g. using a button instead of a gesture).
@property (nonatomic, readonly) BOOL wasTriggeredInteractively;

// Minimum completion percentage, above which the interactive transition finishes.
// If the percentage is lower when the user's touches end, the transition is canceled.
@property (nonatomic, assign) CGFloat minimumGestureCompletionPercentageRequiredToFinish;
- (CGFloat)completionPercentageForGestureAtPoint:(CGPoint)point;

// Called when the assigned gesture recognizer's gesture begins.
// The default implementation of this method does nothing.
- (void)gestureDidBegin;

@end
