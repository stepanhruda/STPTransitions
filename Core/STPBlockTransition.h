#import "STPTransition.h"

@interface STPBlockTransition : STPTransition

+ (instancetype)transitionWithAnimation:(void (^)(UIView *fromView,
                                                  UIView *toView,
                                                  UIView *containerView,
                                                  void (^executeWhenAnimationIsCompleted)(BOOL finished)))animationBlock;

@property (nonatomic, copy) void (^onGestureDidBegin)(void);
@property (nonatomic, copy) void (^onRecognizedInteractiveGestureChanged)(UIGestureRecognizer *gestureRecognizer);
@property (nonatomic, copy) CGFloat (^gestureCompletionForPoint)(CGPoint point);

@end
