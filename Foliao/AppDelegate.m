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
#import "BlocosByLocationViewController.h"
#import "AppConstants.h"

@interface AppDelegate()

- (void)configureParse;
- (void)configureRootViewController;
- (void)takeMyFacebookData;
- (void)showLoginView:(BOOL)animated;
- (void)customizeAppearance;
- (void)customizeBackButton;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureParse];
    [self configureRootViewController];
    [self customizeAppearance];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];
    
    if (![PFUser currentUser]) {
        [self showLoginView:NO];
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
    BlocosByLocationViewController *blocosByPlaceViewController = [[BlocosByLocationViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByPlaceViewController];
    
    ZUUIRevealController *revealController = [[ZUUIRevealController alloc] initWithFrontViewController:navigationController rearViewController:menuViewController];
    self.mainViewController = revealController;
    
    // https://github.com/pkluz/ZUUIRevealController/issues/40
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    revealController.rearViewController.view.frame = CGRectMake(0.0, 0.0, appFrame.size.width - 60, appFrame.size.height + statusBarFrame.size.height);
    
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}

- (void)customizeAppearance
{
    [self customizeBackButton];
}

- (void)customizeBackButton
{
    UIImage *backButtonImage = [[UIImage imageNamed:@"bt-voltar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 43, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
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

- (void)showLoginView:(BOOL)animated
{
    UIViewController *topViewController = [(UINavigationController *)self.mainViewController.frontViewController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [topViewController presentModalViewController:loginViewController animated:animated];
    } else {
        LoginViewController *loginViewController = (LoginViewController *)modalViewController;
        [loginViewController loginFailed];
    }
}

- (void)openSession
{
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [self showLoginView:NO];
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            [self takeMyFacebookData];
            UIViewController *topViewController = [(UINavigationController *)self.mainViewController.frontViewController topViewController];
            UIViewController *modalViewController = [topViewController modalViewController];
            [modalViewController dismissModalViewControllerAnimated:YES];
        }
    }];
}

- (void)takeMyFacebookData
{
    PF_FBRequest *request = [PF_FBRequest requestForMe];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // Store the current user's data
            [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
            [[PFUser currentUser] setObject:[result objectForKey:@"first_name"] forKey:@"firstName"];
            [[PFUser currentUser] setObject:[result objectForKey:@"last_name"] forKey:@"lastName"];
            [[PFUser currentUser] setObject:[result objectForKey:@"first_name"] forKey:@"firstName"];
            [[PFUser currentUser] setObject:[result objectForKey:@"gender"] forKey:@"gender"];
            [[PFUser currentUser] saveInBackground];
        }
    }];
}

- (void)logOut
{   
    [PFUser logOut];
    [self configureRootViewController]; 
    [self showLoginView:YES];
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

#pragma mark - Remote Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PFPush storeDeviceToken:deviceToken];
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
        NSLog(@"Push notifications don't work in the simulator!");
    } else {
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

@end
