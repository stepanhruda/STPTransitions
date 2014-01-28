#import "UIViewController+STPTransitions.h"

#import "STPTransition.h"
#import "STPTransitionCenter.h"

#import <objc/runtime.h>

@interface STPViewControllerContextTransitioning : NSObject <UIViewControllerContextTransitioning>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;
@property (nonatomic, copy) void (^onCompletion)(BOOL finished);

@property (nonatomic, assign) CGRect initialFromFrame;
@property (nonatomic, assign) CGRect initialToFrame;

- (instancetype)initFromViewController:(UIViewController *)fromViewController
                      toViewController:(UIViewController *)toViewController;

@end

@implementation STPViewControllerContextTransitioning

- (instancetype)initFromViewController:(UIViewController *)fromViewController
                      toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
        _fromViewController = fromViewController;
        _toViewController = toViewController;
        _initialFromFrame = fromViewController.view.frame;
        _initialToFrame = toViewController.view.frame;
    }
    return self;
}

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

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    CGRect frame = CGRectZero;
    if (vc == self.fromViewController) {
        frame = self.initialFromFrame;
    } else if (vc == self.toViewController) {
        frame =self.initialToFrame;
    }
    return frame;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    return self.initialToFrame;
}

- (BOOL)transitionWasCancelled {
    return NO;
}

- (BOOL)isAnimated {
    return YES;
}

- (BOOL)isInteractive {
    // TODO: Allow interactive transitions between child view controllers.
    return NO;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
}

- (void)finishInteractiveTransition {
}

- (void)cancelInteractiveTransition {
}

- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationNone;
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
              usingTransition:(STPTransition *)transition
                 onCompletion:(void (^)(void))completion {
    if (![self.transitioningDelegate isKindOfClass:STPTransitionCenter.class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The view controller's transitioning delegate has to be an instance of STPTransitionCenter."
                                     userInfo:nil];
    }
    STPTransitionCenter *center = self.transitioningDelegate;
    [center setNextPushOrPresentTransition:transition fromViewController:self];
    viewControllerToPresent.sourceViewController = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate = center;
    transition.needsRotationFixForModals = YES;
    transition.reverseTransition.needsRotationFixForModals = YES;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)dismissViewControllerUsingTransition:(STPTransition *)transition
                                onCompletion:(void (^)(void))completion {
    if (![self.transitioningDelegate isKindOfClass:STPTransitionCenter.class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The view controller's transitioning delegate has to be an instance of STPTransitionCenter."
                                     userInfo:nil];
    }
    STPTransitionCenter *center = self.transitioningDelegate;
    [center setNextPopOrDismissTransition:transition fromViewController:self];
    transition.needsRotationFixForModals = YES;
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                     usingTransition:(STPTransition *)transition {
    [fromViewController willPerformTransitionAsOuterViewController:transition];
    [fromViewController willMoveToParentViewController:nil];
    [toViewController willPerformTransitionAsInnerViewController:transition];
    [self addChildViewController:toViewController];

    __weak __typeof(self) weakSelf = self;
    void (^onCompletion)(BOOL) = ^(BOOL finished) {
        [toViewController didMoveToParentViewController:weakSelf];
        [fromViewController removeFromParentViewController];
    };

    if (transition) {
        STPViewControllerContextTransitioning *transitioningContext =
        [[STPViewControllerContextTransitioning alloc] initFromViewController:fromViewController
                                                             toViewController:toViewController];
        transitioningContext.containerView = self.view;
        transitioningContext.onCompletion = onCompletion;

        [transition animateTransition:transitioningContext];
    } else {
        [self.view addSubview:toViewController.view];
        [fromViewController.view removeFromSuperview];
        onCompletion(YES);
    }
}

- (void)willPerformTransitionAsInnerViewController:(STPTransition *)transition {}

- (void)willPerformTransitionAsOuterViewController:(STPTransition *)transition {}


@end
