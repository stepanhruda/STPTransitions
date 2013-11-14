#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
           usingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    [self pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
                                usingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    return [self popViewControllerAnimated:animated];
}

@end
