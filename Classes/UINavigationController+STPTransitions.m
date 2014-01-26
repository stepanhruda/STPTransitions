#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition {
    [STPTransitionCenter.sharedInstance setNextTransition:transition forFromViewController:self.topViewController];
    [self pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition {
    [STPTransitionCenter.sharedInstance setNextTransition:transition forFromViewController:self.topViewController];
    return [self popViewControllerAnimated:YES];
}

@end
