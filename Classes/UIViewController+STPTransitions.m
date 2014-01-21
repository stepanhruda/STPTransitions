#import "UIViewController+STPTransitions.h"

#import "STPTransition.h"
#import "STPTransitionCenter.h"

#import <objc/runtime.h>

@interface STPViewControllerContextTransitioning : NSObject<UIViewControllerContextTransitioning>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIView *toViewController;
@property (nonatomic, copy) void (^onCompletion)(BOOL finished);

@end

@implementation STPViewControllerContextTransitioning

- (UIViewController *)viewControllerForKey:(NSString *)key {
    UIViewController *viewController;
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        viewController = self.fromViewController;
    } else if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        viewController = self.toViewController;
    }
    return viewController;
}

- (void)completeTransition:(BOOL)didComplete {
    self.onCompletion(didComplete);
}

@end

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

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     usingTransition:(STPTransition *)transition {

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    STPViewControllerContextTransitioning *transitioningContext = [STPViewControllerContextTransitioning new];
    transitioningContext.containerView = self.view;
    transitioningContext.fromViewController = fromViewController;
    transitioningContext.toViewController = toViewController;
    __weak __typeof(self) weakSelf = self;
    transitioningContext.onCompletion = ^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:weakSelf];
    };

    [transition animateTransition:transitioningContext];

}

- (void)willPerformTransitionAsInnerViewController:(STPTransition *)transition {
}

- (void)willPerformTransitionAsOuterViewController:(STPTransition *)transition {
}


@end
