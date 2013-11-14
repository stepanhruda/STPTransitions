#import <UIKit/UIKit.h>

@class STPTransition;

@interface UINavigationController (STPTransitions)

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
           usingTransition:(STPTransition *)transition;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
                                usingTransition:(STPTransition *)transition;


@end
