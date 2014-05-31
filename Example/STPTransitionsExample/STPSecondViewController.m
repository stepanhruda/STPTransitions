#import "STPSecondViewController.h"

#import "STPSlideUpTransition.h"
#import "STPTransitions.h"


@implementation STPSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpBackButton];
}

- (void)backButtonTapped:(UIButton *)sender {
    // Notice that this controller is completely agnostic of how it was presented.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpBackground {
    self.view.backgroundColor = UIColor.yellowColor;
}

- (void)setUpBackButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"Go back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = self.view.center;
}

@end
