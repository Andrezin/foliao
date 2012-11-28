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

    UIImage *backgroundImage;
    if (IS_IPHONE_5) {
        backgroundImage = [UIImage imageNamed:@"Default-568h"];
    } else {
        backgroundImage = [UIImage imageNamed:@"Default"];
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    bgImageView.frame = CGRectMake(0, -20, backgroundImage.size.width, backgroundImage.size.height);
    [self.view insertSubview:bgImageView belowSubview:self.buttonLogin];
    
    self.buttonLogin.alpha = 0;
    self.buttonLogin.layer.cornerRadius = 3;
    self.buttonLogin.clipsToBounds = YES;
    self.buttonLogin.frame = CGRectMake(self.buttonLogin.frame.origin.x,
                                        [UIScreen mainScreen].bounds.size.height * 0.6,
                                        self.buttonLogin.frame.size.width,
                                        self.buttonLogin.frame.size.height);
    self.spinner.frame = CGRectMake(self.spinner.frame.origin.x,
                                    self.buttonLogin.frame.origin.y + self.buttonLogin.frame.size.height + 10,
                                    self.spinner.frame.size.width,
                                    self.spinner.frame.size.height);
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
