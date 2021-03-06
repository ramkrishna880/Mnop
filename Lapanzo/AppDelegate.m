//
//  AppDelegate.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CategoriesVC.h"
#import "Lapanzo_Client+DataAccess.h"
#import "UIColor+Helpers.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "RearVC.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self performLoginIfNeeded];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)performLoginIfNeeded {
    Lapanzo_Client *dataAcess = [Lapanzo_Client sharedClient];
    UIStoryboard *mainstoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (!dataAcess.isLogged) {
        ViewController *rootViewController = (ViewController *) [mainstoryBoard instantiateViewControllerWithIdentifier:LOGIN_SEGUE];
        self.window.rootViewController = rootViewController;
    } else {
        RearVC *rearViewController = [mainstoryBoard instantiateViewControllerWithIdentifier:@"rearViewId"];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        rearNavigationController.navigationBar.barTintColor = [UIColor navigationBarTintColor];
        UINavigationController *rootViewController = [mainstoryBoard instantiateViewControllerWithIdentifier:CATEGORY_NAV_SEGUEID];
        //      CategoriesVC *rootViewController = (CategoriesVC *) [mainstoryBoard instantiateViewControllerWithIdentifier:CATEGORY_SEGUE];
        
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                        initWithRearViewController:rearNavigationController frontViewController:rootViewController];
        
        mainRevealController.delegate = self;
        self.viewController = mainRevealController;
        self.window.rootViewController = self.viewController;
//        self.window.rootViewController = rootViewController;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
