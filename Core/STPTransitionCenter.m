#import "STPTransitionCenter.h"

#import "STPTransition.h"
#import "UIViewController+STPTransitions.h"

typedef NS_ENUM(NSUInteger, STPTransitionOperation) {
    STPTransitionOperationNone = 0,
    STPTransitionOperationPushPresent,
    STPTransitionOperationPopDismiss
};

@interface STPTransitionCenter ()

@property (nonatomic, strong) NSMapTable *nextTransitionsForOperationsForFromControllers;

@end

@implementation STPTransitionCenter

#pragma mark - Public Interface


- (void)setNextPushOrPresentTransition:(STPTransition *)transition
                    fromViewController:(UIViewController *)viewController {
    [self setNextTransition:transition
               forOperation:STPTransitionOperationPushPresent
         fromViewController:viewController];
}

- (void)setNextPopOrDismissTransition:(STPTransition *)transition
                   fromViewController:(UIViewController *)viewController {
    [self setNextTransition:transition
               forOperation:STPTransitionOperationPopDismiss
         fromViewController:viewController];
}

- (void)removeAllTransitionsForViewController:(UIViewController *)viewController {
    [self.nextTransitionsForOperationsForFromControllers removeObjectForKey:viewController];
}

- (STPTransition *)nextPushOrPresentTransitionFromViewController:(UIViewController *)viewController {
    return [self nextTransitionForOperation:STPTransitionOperationPushPresent
                         fromViewController:viewController];
}

- (STPTransition *)nextPopOrDismissTransitionFromViewController:(UIViewController *)viewController {
    return [self nextTransitionForOperation:STPTransitionOperationPopDismiss
                         fromViewController:viewController];
}

#pragma mark - Object Lifecycle

+ (instancetype)sharedInstance {
    static STPTransitionCenter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [STPTransitionCenter new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextTransitionsForOperationsForFromControllers = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}


#pragma mark - UINavigationControllerDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    STPTransitionOperation transitionOperation = [self transitionOperationForNavigationControllerOperation:operation];
    return [self transitionFromViewController:fromVC toViewController:toVC usingOperation:transitionOperation];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return [self interactorForAnimator:animationController];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self transitionFromViewController:source toViewController:presented usingOperation:STPTransitionOperationPushPresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    UIViewController *toViewController = dismissed.sourceViewController;
    if (!toViewController) {
        toViewController = dismissed.presentingViewController;
    }
    return [self transitionFromViewController:dismissed toViewController:toViewController usingOperation:STPTransitionOperationPopDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self interactorForAnimator:animator];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self interactorForAnimator:animator];
}

#pragma mark - Internal Methods

- (void)messageViewControllersAboutOperation:(STPTransitionOperation)operation
                          fromViewController:(UIViewController *)fromVC
                            toViewController:(UIViewController *)toVC
                                  transition:(STPTransition *)transition {
    UIViewController *outerViewController;
    UIViewController *innerViewController;

    if (operation == STPTransitionOperationPushPresent) {
        outerViewController = fromVC;
        innerViewController = toVC;
    } else if (operation == STPTransitionOperationPopDismiss) {
        outerViewController = toVC;
        innerViewController = fromVC;
    }

    [outerViewController willPerformTransitionAsOuterViewController:transition];
    [innerViewController willPerformTransitionAsInnerViewController:transition];
}

- (id<UIViewControllerInteractiveTransitioning>)interactorForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController {
    id<UIViewControllerInteractiveTransitioning> transitionToUse;
    if ([animationController isKindOfClass:STPTransition.class]) {
        STPTransition *interactiveTransition = (STPTransition *)animationController;
        if (interactiveTransition.wasTriggeredInteractively) {
            transitionToUse = interactiveTransition;
        }
    }
    return transitionToUse;
}

- (STPTransitionOperation)transitionOperationForNavigationControllerOperation:(UINavigationControllerOperation)operation {
    STPTransitionOperation transitionOperation;
    switch (operation) {
        case UINavigationControllerOperationPush:
            transitionOperation = STPTransitionOperationPushPresent;
            break;
        case UINavigationControllerOperationPop:
            transitionOperation = STPTransitionOperationPopDismiss;
            break;
        case UINavigationControllerOperationNone:
        default:
            transitionOperation = STPTransitionOperationNone;
            break;
    }
    return transitionOperation;
}

- (STPTransition *)transitionFromViewController:(UIViewController *)fromViewController
                               toViewController:(UIViewController *)toViewController
                                 usingOperation:(STPTransitionOperation)operation {
    STPTransition *transition = [self nextTransitionForOperation:operation
                                              fromViewController:fromViewController];
    if (transition) {
        if (operation == STPTransitionOperationPushPresent) {
            [self setNextPushOrPresentTransition:nil fromViewController:fromViewController];
            if (transition.reverseTransition) {
                [self setNextPopOrDismissTransition:transition.reverseTransition fromViewController:toViewController];
            }
        } else {
            [self removeAllTransitionsForViewController:fromViewController];
            if (operation == STPTransitionOperationPopDismiss) {
                transition.reversed = YES;
            }
        }

        [self messageViewControllersAboutOperation:operation
                                fromViewController:fromViewController
                                  toViewController:toViewController
                                        transition:transition];
    }
    return transition;
}

- (void)setNextTransition:(STPTransition *)transition
             forOperation:(STPTransitionOperation)operation
       fromViewController:(UIViewController *)viewController {
    NSMutableDictionary *transitionsForOperations = [self.nextTransitionsForOperationsForFromControllers objectForKey:viewController];
    if (!transitionsForOperations && transition) {
        transitionsForOperations = [NSMutableDictionary dictionary];
        [self.nextTransitionsForOperationsForFromControllers setObject:transitionsForOperations forKey:viewController];
    }

    if (transition) {
        [transitionsForOperations setObject:transition forKey:@(operation)];
    } else {
        [transitionsForOperations removeObjectForKey:@(operation)];
    }

    if (transitionsForOperations.count < 1) {
        [self removeAllTransitionsForViewController:viewController];
    }
}

- (STPTransition *)nextTransitionForOperation:(STPTransitionOperation)operation
                           fromViewController:(UIViewController *)viewController {
    NSDictionary *transitionsForOperations = [self.nextTransitionsForOperationsForFromControllers objectForKey:viewController];
    STPTransition *transition = [transitionsForOperations objectForKey:@(operation)];
    return transition;
}

@end
