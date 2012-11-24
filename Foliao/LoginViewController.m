//
//  LoginViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;

- (IBAction)performLogin:(id)sender;

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonLogin.alpha = 0;
    self.buttonLogin.layer.cornerRadius = 3;
    self.buttonLogin.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.5 animations:^{
        self.buttonLogin.alpha = 1;
    }];
}

- (IBAction)performLogin:(id)sender
{
    [self.spinner startAnimating];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

@end
