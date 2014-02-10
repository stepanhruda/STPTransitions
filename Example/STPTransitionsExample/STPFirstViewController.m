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
    //uncomment for slide up/down transition
//    STPSlideUpTransition *transition = [STPSlideUpTransition new];
//    transition.reverseTransition = [STPSlideUpTransition new];
    
    //card transition adapted from Colin Eberhardt's VCTransitionsLibrary
    STPCardTransition *transition = [STPCardTransition new];
    transition.reverseTransition = [STPCardTransition new];
    
    //contrived example; one probably wouldn't use the card animation behind a nav
    //bar like this but serves well for demo purposes
    [self.navigationController pushViewController:[STPSecondViewController new]
                                  usingTransition:transition];
}

@end
