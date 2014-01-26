#import "STPFirstViewController.h"

#import "STPSlideUpTransition.h"
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
    transition.reverseTransition = [STPSlideUpTransition new];

    [self.navigationController pushViewController:[STPSecondViewController new]
                                  usingTransition:transition];
}

@end
