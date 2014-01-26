#import "STPAppDelegate.h"

#import "STPFirstViewController.h"

#import "STPTransitions.h"

@implementation STPAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    STPFirstViewController *viewController = [STPFirstViewController new];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    // This is the tits. Don't forget to do this!
    navigationController.delegate = STPTransitionCenter.sharedInstance;

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return NO;
}

@end
