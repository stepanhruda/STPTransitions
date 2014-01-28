#import "UINavigationController+STPTransitions.h"

#import "STPTransitionCenter.h"

@implementation UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition {
    if (![self.delegate isKindOfClass:STPTransitionCenter.class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The navigation controller's delegate has to be a instance of STPTransitionCenter."
                                     userInfo:nil];
    }
    STPTransitionCenter *center = self.delegate;
    [center setNextPushOrPresentTransition:transition fromViewController:self.topViewController];
    [self pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition {
    if (![self.delegate isKindOfClass:STPTransitionCenter.class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The navigation controller's delegate has to be a instance of STPTransitionCenter."
                                     userInfo:nil];
    }
    STPTransitionCenter *center = self.delegate;
    [center setNextPopOrDismissTransition:transition fromViewController:self.topViewController];
    return [self popViewControllerAnimated:YES];
}

@end
