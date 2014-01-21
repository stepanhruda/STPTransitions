#import <UIKit/UIKit.h>

@class STPTransition;

@interface UIViewController (STPTransitions)

@property (nonatomic, weak) UIViewController *sourceViewController;

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion
              usingTransition:(STPTransition *)transition;

- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion
                      usingTransition:(STPTransition *)transition;

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     usingTransition:(STPTransition *)transition;


- (void)willPerformTransitionAsOuterViewController:(STPTransition *)transition;
- (void)willPerformTransitionAsInnerViewController:(STPTransition *)transition;

@end
