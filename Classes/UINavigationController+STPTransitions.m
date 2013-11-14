#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    [self pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    return [self popViewControllerAnimated:YES];
}

@end
