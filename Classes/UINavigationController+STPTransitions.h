#import <UIKit/UIKit.h>

@class STPTransition;

@interface UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
           usingTransition:(STPTransition *)transition;

- (UIViewController *)popViewControllerUsingTransition:(STPTransition *)transition;


@end
