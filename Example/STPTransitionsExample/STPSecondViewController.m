#import "STPSecondViewController.h"

@implementation STPSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"Go back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    button.center = self.view.center;
}

- (void)buttonTapped:(UIButton *)sender {
    // Notice that this controller doesn't know anything about the transition that presented it.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
