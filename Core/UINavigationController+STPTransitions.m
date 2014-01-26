#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition {
    [STPTransitionCenter.sharedInstance setNextPushOrPresentTransition:transition fromViewController:self.topViewController];
    [self pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition {
    [STPTransitionCenter.sharedInstance setNextPopOrDismissTransition:transition fromViewController:self.topViewController];
    return [self popViewControllerAnimated:YES];
}

@end
