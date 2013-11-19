#import "STPTransitionCenter.h"

#import "STPTransition.h"
#import "UIViewController+STPTransitions.h"

@interface STPTransitionCenter ()

@property (nonatomic, strong) NSMapTable *reverseTransitionsForViewControllers;

@end

@implementation STPTransitionCenter


#pragma mark - Object Lifecycle

+ (instancetype)sharedInstance {
    static STPTransitionCenter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [STPTransitionCenter new];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _defaultBackGestureEnabled = YES;
        _reverseTransitionsForViewControllers = [NSMapTable weakToStrongObjectsMapTable];
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

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    STPTransition *transition = [self.reverseTransitionsForViewControllers objectForKey:viewController];

    if (!transition.gestureRecognizer && self.hasDefaultBackGestureEnabled) {

        UIScreenEdgePanGestureRecognizer *recognizer = [UIScreenEdgePanGestureRecognizer new];
        recognizer.edges = UIRectEdgeLeft;
        [navigationController.view addGestureRecognizer:recognizer];

        __weak UINavigationController *weakNavigationController = navigationController;
        transition.gestureRecognizer = recognizer;
        transition.onGestureTriggered = ^{
            [weakNavigationController popViewControllerAnimated:YES];
        };
    }
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

- (void)messageViewControllersForOperation:(STPTransitionOperation)operation
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
    if ([animationController isKindOfClass:[STPTransition class]]) {
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
        case UINavigationControllerOperationNone:
            transitionOperation = STPTransitionOperationNone;
            break;
        case UINavigationControllerOperationPush:
            transitionOperation = STPTransitionOperationPushPresent;
            break;
        case UINavigationControllerOperationPop:
            transitionOperation = STPTransitionOperationPopDismiss;
            break;
        default:
            transitionOperation = STPTransitionOperationNone;
            break;
    }
    return transitionOperation;
}

- (STPTransition *)transitionFromViewController:(UIViewController *)fromViewController
                                            toViewController:(UIViewController *)toViewController
                                              usingOperation:(STPTransitionOperation)operation {
    STPTransition *transition;
    if (self.nextTransition) {

        transition = self.nextTransition;
        self.nextTransition = nil;

    } else if (operation == STPTransitionOperationPopDismiss &&
               [self.reverseTransitionsForViewControllers objectForKey:fromViewController]) {

        transition = [self.reverseTransitionsForViewControllers objectForKey:fromViewController];
        if (transition.isReversible) {
            transition.reverse = YES;
        }

    }

    [self messageViewControllersForOperation:operation fromViewController:fromViewController toViewController:toViewController transition:transition];

    if (operation == STPTransitionOperationPushPresent) {
        if (transition.reverseTransition) {
            [self.reverseTransitionsForViewControllers setObject:transition.reverseTransition forKey:toViewController];
        } else if (transition.isReversible) {
            [self.reverseTransitionsForViewControllers setObject:transition forKey:toViewController];
        }
    }
    return transition;
}

@end
