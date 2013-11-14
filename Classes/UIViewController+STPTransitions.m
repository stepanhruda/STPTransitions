#import "UIViewController+STPTransitions.h"

#import "STPTransitionCenter.h"

#import <objc/runtime.h>

static void *STPTransitionsSourceController = &STPTransitionsSourceController;

@implementation UIViewController (STPTransitions)

- (void)setSourceViewController:(UIViewController *)sourceViewController {
    objc_setAssociatedObject(self, STPTransitionsSourceController, sourceViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)sourceViewController {
    return objc_getAssociatedObject(self, STPTransitionsSourceController);
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion
              usingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    viewControllerToPresent.sourceViewController = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate = [STPTransitionCenter sharedInstance];
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion
                      usingTransition:(STPTransition *)transition {
    [STPTransitionCenter sharedInstance].nextTransition = transition;
    [self dismissViewControllerAnimated:flag completion:completion];
}

- (void)willPerformTransitionAsInnerViewController:(STPTransition *)transition {
}

- (void)willPerformTransitionAsOuterViewController:(STPTransition *)transition {
}


@end
