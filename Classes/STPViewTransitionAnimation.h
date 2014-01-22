@protocol STPViewTransitionAnimation <NSObject>

+ (void)transitionFromView:(UIView *)oldView
                    toView:(UIView *)newView
              asSubviewsOf:(UIView *)parentView
     usingReverseAnimation:(BOOL)shouldReverseAnimation
              onCompletion:(void (^)(BOOL finished))completion;

@end
