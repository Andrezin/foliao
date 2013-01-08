//
//  NavigationRootLevelViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BaseViewController.h"
#import "ThemeManager.h"

@interface BaseViewController()

- (void)addGestureRecognizerToNavigationBar;
- (BOOL)isRootViewController;
- (void)addMenuButton;
- (void)addBackButton;

@end


@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self addGestureRecognizerToNavigationBar];
    
    if (![self isRootViewController])
        [self addBackButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self isRootViewController])
        [self addMenuButton];
}

- (void)addGestureRecognizerToNavigationBar
{
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController
                                            action:@selector(revealGesture:)];
    
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
}

- (BOOL)isRootViewController
{
    return self == self.navigationController.viewControllers[0];
}

- (void)addMenuButton
{
    UIImage *menuButtonBackground = [[ThemeManager currentTheme] menuButtonImage];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuButtonBackground style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    menuButton.accessibilityLabel = @"Botão Menu";
    
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 30)];
    
    UIImage *whiteBackground = [[UIImage imageNamed:@"bt-branco"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [backButton setBackgroundImage:whiteBackground forState:UIControlStateNormal];
    [backButton setImage:[[ThemeManager currentTheme] backButtonImage] forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(popViewControllerAnimated)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)popViewControllerAnimated
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
