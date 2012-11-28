//
//  NavigationRootLevelViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BaseViewController.h"


@interface BaseViewController()

- (void)addMenuButton;

@end


@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self == self.navigationController.viewControllers[0]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar"] forBarMetrics:UIBarMetricsDefault];
        
        if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)]) {
            UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
            [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
            
            [self addMenuButton];
        }
    }
}

- (void)addMenuButton
{
    UIImage *menuButtonBackground = [UIImage imageNamed:@"bt-menu-laranja"];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 30)];
    [menuButton setBackgroundImage:menuButtonBackground forState:UIControlStateNormal];
    [menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

@end
