STPTransitions
==============

# Usage

## UINavigationController pushing/popping

STPTransitions adds a category to UINavigationController so that you
can push and pop view controllers with custom transitions.

These transitions can be done with either a custom transition class that extends `STPTransition` 
or by instantiating `STPTransition` with an ad-hoc animation block.

```objective-c
[self.navigationController pushViewController:transactionViewController
                              usingTransition:[CustomTransitionClass new]];
```
```objective-c
STPTransition *transitionWithAdHockBlock = 
    [STPTransition transitionWithAnimation:^(id<UIViewControllerContextTransitioning> transitionContext) {}];
   
[self.navigationController pushViewController:transactionViewController
                                  usingTransition:transitionWithAdHockBlock];
```
### Example with a custom transition class

`SKTransitionZoomAndFade.h`
```objective-c
#import "STPTransition.h"

@interface SKTransitionZoomAndFade : STPTransition

@end
```

`SKTransitionZoomAndFade.m`
```objective-c
#import "SKTransitionZoomAndFade.h"

@implementation SKTransitionZoomAndFade

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIView *container = [transitionContext containerView];

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toVC.view.alpha = 0.0f;
    [container insertSubview:toVC.view belowSubview:fromVC.view];

    [UIView animateWithDuration:0.3f
                     animations:^{
                         fromVC.view.alpha = 0.0f;
                         fromVC.view.transform = CGAffineTransformMakeScale(5.0f, 5.0f);
                         toVC.view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                         fromVC.view.alpha = 1.0f;
                         fromVC.view.transform = CGAffineTransformIdentity;
                     }];
}

@end
```

#### Pushing with custom class

```objective-c
[self.navigationController pushViewController:transactionViewController
                              usingTransition:[SKTransitionZoomAndFade new]];
```

### Using an animation block

```objective-c
STPTransition *zoomAndFade = [STPTransition transitionWithAnimation:^(id<UIViewControllerContextTransitioning> transitionContext) {
    UIView *container = [transitionContext containerView];

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toVC.view.alpha = 0.0f;
    [container insertSubview:toVC.view belowSubview:fromVC.view];

    [UIView animateWithDuration:0.3f
                     animations:^{
                         fromVC.view.alpha = 0.0f;
                         fromVC.view.transform = CGAffineTransformMakeScale(5.0f, 5.0f);
                         toVC.view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                         fromVC.view.alpha = 1.0f;
                         fromVC.view.transform = CGAffineTransformIdentity;
                     }];
}];

[self.navigationController pushViewController:transactionViewController
                              usingTransition:zoomAndFade];
```
