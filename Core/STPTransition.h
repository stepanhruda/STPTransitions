@import UIKit;

@interface STPTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

/**
 Animation method executed during the transition. Override in your subclass.

 @param fromview The view from which we're animating.
 @param toView The view to which we're animating.
 @param containerView The view in which all the animations are taking place.
 @param onCompletion You're responsible for executing this block after animation is finished.
 
 @discussion fromView is already a subview of containerView. toView is not, add it when it becomes required.
 Don't forget to execute the onCompletion block.
 */
//
- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion;

/**
 Transition's duration. You are responsible for assigning this.
 @discussion Duration is used for other views to synchronize their animations, e.g. the navigation bar.
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 Completion block executed when the transition is finished.
 @param transitionCompleted Is NO if transition's original view is still showing.
 */
@property (nonatomic, copy) void (^onCompletion)(BOOL transitionCompleted);

#pragma mark - Modal Transitions

/**
 The way custom modal transitions are treated in landscape mode is very strange at the moment.
 This property is automatically assigned if the transition is used for a modal and STPTransitions does its best to try to fix it for you.
 */
@property (nonatomic, assign) BOOL needsRotationFixForModals;

#pragma mark - Reverse Transitions

/**
 Transition is marked as reversed when being used while popping or dismissing a view controller.
 Take advantage of this property to implement both ways of a transition's animation in one class.
 
 @discussion You can also assign this property manually to choose which way a transition goes when switching between two child view controllers.
 */
@property (nonatomic, assign, getter = isReversed) BOOL reversed;

/**
 When pushing or presenting a view controller, the transition assigned to this property gets used for the returning operation (i.e. pop or dismiss).
 @discussion This property is ignored when popping, dismissing and switching child view controllers.
 */
@property (nonatomic, strong) STPTransition *reverseTransition;

#pragma mark - Gesture Recognition

/**
 Gesture recognizer to trigger the transition via a gesture. You're responsible for adding the recognizer to the appropriate view.
 @discussion Although it is used for interactive transitions, it does _not_ automatically make the transition interactive.
 A regular transition can be kicked off via this recognizer.
 */
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;


/**
 Called when the assigned gesture recognizer's gesture begins. The default implementation of this method does nothing.
 */
- (void)gestureDidBegin;

#pragma mark - Interactive Transitions

/**
 This property has to be YES, if the transition can be interactive.
 */
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

/**
 Returns YES if the transition was kicked off interactively using the recognizer.
 @discussion Even interactive transition can happen non-interactively (e.g. using a button instead of a gesture).
 */
@property (nonatomic, readonly) BOOL wasTriggeredInteractively;

/**
 Minimum completion percentage, above which the interactive transition finishes.
 If the percentage is lower when the user's touches end, the transition is canceled.
 */
@property (nonatomic, assign) CGFloat minimumGestureCompletionPercentageRequiredToFinish;

/**
 Override in your interactive transition subclass.
 
 @param point Current gesture's position.
 @returns Transition's completion percentage as a number between 0.0 and 1.0.
 */
- (CGFloat)completionPercentageForGestureAtPoint:(CGPoint)point;

@end
