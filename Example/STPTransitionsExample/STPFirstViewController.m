#import "STPFirstViewController.h"

#import "STPSlideUpTransition.h"
#import "STPCardTransition.h"
#import "STPSecondViewController.h"
#import "STPTransitions.h"

@implementation STPFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"Go to second screen" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = self.view.center;
}

- (void)buttonTapped:(UIButton *)sender {
    STPSlideUpTransition *transition = [STPSlideUpTransition new];

    STPSecondViewController *secondViewController = [STPSecondViewController new];

    UIGestureRecognizer *recognizer = [self addGestureRecognizerToView:secondViewController.view];

    STPTransition *reverseInteractiveTransition = [self interactiveTransitionWithGestureRecognizer:recognizer];
    transition.reverseTransition = reverseInteractiveTransition;

    [self.navigationController pushViewController:secondViewController
                                  usingTransition:transition];
}


- (UIGestureRecognizer *)addGestureRecognizerToView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *recognizer = [UIScreenEdgePanGestureRecognizer new];
    recognizer.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:recognizer];
    return recognizer;
}

- (STPTransition *)interactiveTransitionWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    STPTransition *transition = [STPSlideUpTransition new];
    transition.gestureRecognizer = gestureRecognizer;

    __weak __typeof(self) weakSelf = self;
    transition.onGestureTriggered = ^(UIGestureRecognizer *recognizer) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    transition.shouldCompleteTransitionOnGestureEnded = ^BOOL (UIGestureRecognizer *recognizer, CGFloat completion) {
        return completion > 0.4f;
    };
    transition.completionPercentageForGestureRecognizerState = ^CGFloat (UIGestureRecognizer *recognizer) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGPoint point = [recognizer locationInView:window];
        CGFloat windowWidth = CGRectGetWidth(window.frame);
        return point.x / (windowWidth / 1.5f);
    };

    return transition;
}

@end
