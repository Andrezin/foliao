//
//  NavigationRootLevelViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "NavigationRootLevelViewController.h"
#import "AppDelegate.h"


@interface NavigationRootLevelViewController()

- (void)addMenuButton;
- (void)addLogoutButton;

@end


@implementation NavigationRootLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"] forBarMetrics:UIBarMetricsDefault];
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)]) {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        [self addMenuButton];
        [self addLogoutButton];
	}
}

- (void)addMenuButton
{
    UIImage *menuButtonBackground = [UIImage imageNamed:@"bt-menu.png"];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuButtonBackground.size.width, menuButtonBackground.size.height)];
    [menuButton setBackgroundImage:menuButtonBackground forState:UIControlStateNormal];
    [menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (void)addLogoutButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
}

-(void)logoutButtonWasPressed:(id)sender
{
    [[PFFacebookUtils session] closeAndClearTokenInformation];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate sessionStateChanged:nil];
}

@end
