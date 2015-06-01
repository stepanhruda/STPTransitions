#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition {
    if (![self.delegate isKindOfClass:STPTransitionCenter.class]) {
        self.delegate = STPTransitionCenter.sharedInstance;
    }
    STPTransitionCenter *center = (STPTransitionCenter *)self.delegate;
    [center setNextPushOrPresentTransition:transition fromViewController:self.topViewController];
    [self pushViewController:viewController animated:YES];
}


- (void)popToViewController:(UIViewController*)viewController
            usingTransition:(STPTransition *)transition {
    if (![self.delegate isKindOfClass:STPTransitionCenter.class]) {
        self.delegate = STPTransitionCenter.sharedInstance;
    }
    STPTransitionCenter *center = (STPTransitionCenter *)self.delegate;
    [center setNextPopOrDismissTransition:transition fromViewController:self.topViewController];
    [self popToViewController:viewController animated:YES];
}


- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition {
    if (![self.delegate isKindOfClass:STPTransitionCenter.class]) {
        self.delegate = STPTransitionCenter.sharedInstance;
    }
    STPTransitionCenter *center = (STPTransitionCenter *)self.delegate;
    [center setNextPopOrDismissTransition:transition fromViewController:self.topViewController];
    return [self popViewControllerAnimated:YES];
}

@end
