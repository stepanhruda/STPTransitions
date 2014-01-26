@class STPTransition;

@interface STPTransitionCenter : NSObject <UINavigationControllerDelegate,
                                           UIViewControllerTransitioningDelegate>

+ (instancetype)sharedInstance;

- (void)setNextTransition:(STPTransition *)transition
    forFromViewController:(UIViewController *)controller;

@end
