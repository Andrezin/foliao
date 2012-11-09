//
//  AppDelegate.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

#import "LoginViewController.h"
#import "ZUUIRevealController.h"
#import "MenuViewController.h"
#import "BlocosByPlaceViewController.h"
#import "AppConstants.h"

@interface AppDelegate()

- (void)configureParse;
- (void)configureRootViewController;
- (void)showLoginView;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureParse];
    [self configureRootViewController];
    
    if ([[PFFacebookUtils session] state] == PF_FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
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
    self.mainViewController = revealController;
    
    // https://github.com/pkluz/ZUUIRevealController/issues/40
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    revealController.rearViewController.view.frame = CGRectMake(0.0, 0.0, appFrame.size.width, appFrame.size.height + statusBarFrame.size.height);
    
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)showLoginView
{
    UIViewController *topViewController = [(UINavigationController *)self.mainViewController.frontViewController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        LoginViewController *loginViewController = (LoginViewController *)modalViewController;
        [loginViewController loginFailed];
    }
}

- (void)sessionStateChanged:(NSError *)error
{
    PF_FBSessionState state = [[PFFacebookUtils session] state];
    
    switch (state) {
        case PF_FBSessionStateOpen: {
            UIViewController *topViewController =
            [(UINavigationController *)self.mainViewController.frontViewController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case PF_FBSessionStateClosed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [(UINavigationController *)self.mainViewController.frontViewController popToRootViewControllerAnimated:NO];
            
            [[PFFacebookUtils session] closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
        [self sessionStateChanged:error];
    }];
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
    [[PFFacebookUtils session] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
