#import <Foundation/Foundation.h>

@class STPTransition;

@interface STPTransitionCenter : NSObject <UINavigationControllerDelegate,
                                            UIViewControllerTransitioningDelegate>

@property (nonatomic, assign, getter = hasDefaultBackGestureEnabled) BOOL defaultBackGestureEnabled;
@property (nonatomic, strong) STPTransition *nextTransition;

+ (instancetype)sharedInstance;

@end
