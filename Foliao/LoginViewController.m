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

@property (strong, nonatomic) UIImageView *imageViewCover;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackgroundShadow;
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
    
    self.imageViewCover = [[UIImageView alloc] initWithImage:backgroundImage];
    self.imageViewCover.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self.view addSubview:self.imageViewCover];
    
    self.imageViewBackgroundShadow.frame = [[UIScreen mainScreen] bounds];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0 animations:^{
        self.imageViewCover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.imageViewCover removeFromSuperview];
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
