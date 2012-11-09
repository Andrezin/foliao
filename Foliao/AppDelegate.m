//
//  AppDelegate.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#import "ZUUIRevealController.h"
#import "MenuViewController.h"
#import "BlocosByPlaceViewController.h"
#import "AppConstants.h"

@interface AppDelegate()

- (void)configureParse;
- (void)configureRootViewController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureParse];
    [self configureRootViewController];
    return YES;
}

- (void)configureParse
{
    [Parse setApplicationId:@"Zz8V3uYUdxJGgUsDlVhpt8egBxKwI80Vyh6trNXR"
                  clientKey:@"HVVNEil3EDwDrU2kLTlbk24urzszqr7djx7Qlh6q"];
    
    [PFFacebookUtils initializeWithApplicationId:kFACEBOOK_APP_ID];
}

- (void)configureRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    BlocosByPlaceViewController *blocosByPlaceViewController = [[BlocosByPlaceViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByPlaceViewController];
    
    ZUUIRevealController *revealController = [[ZUUIRevealController alloc] initWithFrontViewController:navigationController rearViewController:menuViewController];
    self.viewController = revealController;
    
    // https://github.com/pkluz/ZUUIRevealController/issues/40
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    revealController.rearViewController.view.frame = CGRectMake(0.0, 0.0, appFrame.size.width, appFrame.size.height + statusBarFrame.size.height);
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
