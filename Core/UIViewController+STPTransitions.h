@import UIKit;

@class STPTransition;

@interface UIViewController (STPTransitions)

@property (nonatomic, weak) UIViewController *sourceViewController;
@property (nonatomic, assign) BOOL fixInterfaceOrientationRotation;

- (void)presentViewController:(UIViewController *)viewControllerToPresent
              usingTransition:(STPTransition *)transition
                 onCompletion:(void (^)(void))completion;

- (void)dismissViewControllerUsingTransition:(STPTransition *)transition
                                onCompletion:(void (^)(void))completion;

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     usingTransition:(STPTransition *)transition;

// You can override these methods in your UIViewController subclass to react to a transition.
// Outer view controller is either lower in the navigation stack, or the presenting controller.
- (void)willPerformTransitionAsOuterViewController:(STPTransition *)transition;
// Inner view controller is either higher in the navigation stack, or the presented controller.
- (void)willPerformTransitionAsInnerViewController:(STPTransition *)transition;

/**
 Sent to the view controller before performing a one-step user interface rotation.

 @param toInterfaceOrientation The new orientation for the user interface. The possible values are described in UIInterfaceOrientation.
 @param duration The duration of the pending rotation, measured in seconds.
 
 @warning Use this method instead of -willAnimateRotationToInterfaceOrientation:duration:.
 Views aren't rotated correctly for landscape modal transition and STPTransitions fixes the rotation
 by overriding the aforementioned method in a category.
 */
- (void)willAnimateRotationWithFixedOrientationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                                             duration:(NSTimeInterval)duration;

@end
