#import "STPBlockTransition.h"

@interface STPBlockTransition()

@property (nonatomic, copy) void (^animationBlock)(UIView *, UIView *, UIView *, void (^)(BOOL));

@end

@implementation STPBlockTransition

#pragma mark - Public Interface

+ (instancetype)transitionWithAnimation:(void (^)(UIView *, UIView *, UIView *, void (^)(BOOL)))animationBlock {
    STPBlockTransition *transition = [self new];
    transition.animationBlock = animationBlock;
    return transition;
}

#pragma mark - STPTransition Overrides

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion {
    if (self.animationBlock) {
        self.animationBlock(fromView, toView, containerView, onCompletion);
    }
}

- (void)gestureDidBegin {
    if (self.onGestureDidBegin) {
        self.onGestureDidBegin();
    }
}

- (void)interactiveGestureChanged:(UIGestureRecognizer *)gestureRecognizer {
    if (self.onRecognizedInteractiveGestureChanged) {
        self.onRecognizedInteractiveGestureChanged(gestureRecognizer);
    }
}

- (CGFloat)completionPercentageForGestureAtPoint:(CGPoint)point {
    CGFloat completionPercentage;
    if (self.gestureCompletionForPoint) {
        completionPercentage = self.gestureCompletionForPoint(point);
    } else {
        completionPercentage = [super completionPercentageForGestureAtPoint:point];
    }
    return completionPercentage;
}

@end
