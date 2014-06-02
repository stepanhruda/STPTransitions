#import "UIGestureRecognizer+STPTransition.h"

#import "STPTransition.h"

#import <objc/runtime.h>

@implementation UIGestureRecognizer (STPTransition)

- (STPTransition *)stp_transition {
    return objc_getAssociatedObject(self, @selector(stp_transition));
}

- (void)setStp_transition:(STPTransition *)stp_transition {
    stp_transition.gestureRecognizer = self;
    objc_setAssociatedObject(self, @selector(stp_transition), stp_transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
