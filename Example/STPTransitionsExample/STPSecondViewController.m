#import "STPSecondViewController.h"

#import "STPCardTransition.h"
#import "STPSlideUpTransition.h"
#import "STPTransitions.h"

@interface STPThirdViewController : UIViewController

@end

@implementation STPSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLabel];
    [self setUpBackground];
//    [self setUpBackButton];
//    [self setUpForwardButton];
}

- (void)backButtonTapped:(UIButton *)sender {
    // Notice that this controller is completely agnostic of how it was presented.
//    [self.navigationController popViewControllerUsingTransition:[STPSlideUpTransition new]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setUpBackground {
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)setUpLabel {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"like a record baby,\nright round\nround round";
    label.text = label.text.uppercaseString;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textColor = [UIColor colorWithRed:0.071 green:0.592 blue:0.576 alpha:1.000];
    [label sizeToFit];
    [self.view addSubview:label];
    label.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
}


- (void)setUpBackButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.302 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:@"one more time" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 40);
}

//- (void)setUpForwardButton {
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.302 alpha:1.000] forState:UIControlStateNormal];
//    [button setTitle:@"Third screen" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(forwardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:button];
//    button.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
//}

- (void)forwardButtonTapped:(UIButton *)sender {
    STPTransition *transition = [STPCardTransition new];
    transition.reverseTransition = [STPCardTransition new];
    [self.navigationController pushViewController:[STPThirdViewController new] usingTransition:transition];
}

@end

@implementation STPThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpBackButton];
    [self setUpAllTheWayBackButton];
}

- (void)setUpBackground {
    self.view.backgroundColor = UIColor.brownColor;
}

- (void)setUpBackButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.302 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:@"Go back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
}

- (void)setUpAllTheWayBackButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.302 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:@"All the way back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allTheWayBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = CGPointMake(self.view.center.x, self.view.center.y);
}

- (void)backButtonTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)allTheWayBackButtonTapped:(UIButton *)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}

@end
