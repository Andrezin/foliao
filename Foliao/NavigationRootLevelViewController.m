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


@implementation NavigationRootLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Folião";
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)]) {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"Menu"
                                                 style:UIBarButtonItemStylePlain
                                                 target:self.navigationController.parentViewController
                                                 action:@selector(revealToggle:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"Logout"
                                                  style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(logoutButtonWasPressed:)];
	}
}

-(void)logoutButtonWasPressed:(id)sender
{
    [[PFFacebookUtils session] closeAndClearTokenInformation];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate sessionStateChanged:nil];
}

@end
