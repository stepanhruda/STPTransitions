#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STPTransitionOperation) {
    STPTransitionOperationNone = 0,
    STPTransitionOperationPushPresent,
    STPTransitionOperationPopDismiss
};

@interface STPTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext))animateAdHoc;

@property (nonatomic, strong) STPTransition *reverseTransition;
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

@property (nonatomic, copy) void (^onGestureTriggered)(void);
@property (nonatomic, copy) void (^onInteractiveGestureChanged)(UIGestureRecognizer *gestureRecognizer);
@property (nonatomic, copy) CGFloat (^gestureCompletionForPoint)(CGPoint point);

@property (nonatomic, copy) void (^onAnimationEnded)(BOOL transitionCompleted);

@property (nonatomic, readonly) BOOL wasTriggeredInteractively;

- (CGFloat)completionForGesturePoint:(CGPoint)point;

@end
