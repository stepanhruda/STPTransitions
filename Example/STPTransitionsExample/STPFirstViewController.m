#import "STPFirstViewController.h"

#import "STPCardTransition.h"
#import "STPRotateFadeTransition.h"
#import "STPSecondViewController.h"
#import "STPSlideUpTransition.h"
#import "STPTransitions.h"

@implementation STPFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self setUpLabel];
    [self setUpGestureRecognizer];
    [self setUpSecondScreenButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setUpLabel {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"You spin me \nright round,\nbaby right round";
    label.text = label.text.uppercaseString;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textColor = [UIColor colorWithRed:0.071 green:0.592 blue:0.576 alpha:1.000];
    [label sizeToFit];
    [self.view addSubview:label];
    label.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
}

- (void)setUpGestureRecognizer {
    STPTransition *transition = [STPRotateFadeTransition new];
    transition.reverseTransition = [STPRotateFadeTransition new];

    [self setUpForwardTransition:transition];
    [self setUpReverseTransition:transition.reverseTransition];
}

- (void)setUpForwardTransition:(STPTransition *)transition {
    [self addGestureRecognizerForTransition:transition];

    __weak __typeof(self) weakSelf = self;
    transition.onGestureTriggered = ^(STPTransition *transition, UIGestureRecognizer *recognizer) {
        [weakSelf.navigationController pushViewController:[STPSecondViewController new]
                                          usingTransition:transition];
    };

    transition.completionPercentageForGestureRecognizerState = ^CGFloat (UIGestureRecognizer *recognizer) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        CGPoint translation = [panGestureRecognizer translationInView:recognizer.view];
        CGFloat completion = (2.0f * -translation.x) / CGRectGetWidth(recognizer.view.frame);
        return completion;
    };

    transition.shouldCompleteTransitionOnGestureEnded = ^BOOL (UIGestureRecognizer *recognizer, CGFloat completion) {
        return completion > 0.4f;
    };

    transition.onCompletion = ^(STPTransition *transition, BOOL transitionWasCompleted) {
        if (transitionWasCompleted) {
            [weakSelf addGestureRecognizerForTransition:transition.reverseTransition];
        }
    };
}

- (void)setUpReverseTransition:(STPTransition *)transition {
    __weak __typeof(self) weakSelf = self;
    transition.onGestureTriggered = ^(STPTransition *transition, UIGestureRecognizer *recognizer) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

    transition.completionPercentageForGestureRecognizerState = ^CGFloat (UIGestureRecognizer *recognizer) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        CGPoint translation = [panGestureRecognizer translationInView:recognizer.view];
        CGFloat completion = (2.0f * translation.x) / CGRectGetWidth(recognizer.view.frame);
        return completion;
    };

    transition.shouldCompleteTransitionOnGestureEnded = ^BOOL (UIGestureRecognizer *recognizer, CGFloat completion) {
        return completion > 0.4f;
    };

    transition.onCompletion = ^(STPTransition *transition, BOOL transitionWasCompleted) {
        if (transitionWasCompleted) {
            [weakSelf setUpGestureRecognizer];
        }
    };
}

- (void)addGestureRecognizerForTransition:(STPTransition *)transition {
    UIPanGestureRecognizer *recognizer = [UIPanGestureRecognizer new];
    [UIApplication.sharedApplication.keyWindow addGestureRecognizer:recognizer];
    recognizer.stp_transition = transition;
}

- (void)setUpSecondScreenButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.302 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:@"as you wish" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 40);
}

- (void)buttonTapped:(UIButton *)sender {
    STPTransition *transition = [STPRotateFadeTransition new];

    STPSecondViewController *secondViewController = [STPSecondViewController new];

    transition.reverseTransition = [STPRotateFadeTransition new];

    [self.navigationController pushViewController:secondViewController
                                  usingTransition:transition];
}

@end
