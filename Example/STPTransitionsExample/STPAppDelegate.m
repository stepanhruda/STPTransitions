#import "STPAppDelegate.h"

#import "STPFirstViewController.h"

#import "STPTransitions.h"

@implementation STPAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

    STPFirstViewController *viewController = [STPFirstViewController new];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    navigationController.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.929 blue:0.816 alpha:1.000];

    // This is the tits. Don't forget to do this!
    navigationController.delegate = STPTransitionCenter.sharedInstance;

    self.window.rootViewController = navigationController;

    return NO;
}

@end
