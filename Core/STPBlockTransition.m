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

@end
