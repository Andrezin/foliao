//
//  BlocoViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "BlocoViewController.h"

#import "SVProgressHUD.h"

@interface BlocoViewController ()

@property (strong, nonatomic) NSArray *parades;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *checkInButton;

- (void)customizeBackButton;
- (void)sizeScrollViewToFit;
- (void)popViewController;
- (void)fillBlocoInfoInBackground;
- (void)confirmPresenceInParade:(PFObject *)parade;

- (IBAction)checkInButtonTapped:(UIButton *)sender;

@end


@implementation BlocoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeBackButton];
    [self sizeScrollViewToFit];
    [self fillBlocoInfoInBackground];
}

- (void)customizeBackButton
{
    UIImage *backButtonImage = [UIImage imageNamed:@"bt-voltar"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 30)];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sizeScrollViewToFit
{
    CGFloat scrollViewHeight = 0.0f;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    for (UIView *view in self.scrollView.subviews) {
        if (!view.hidden) {
            CGFloat y = view.frame.origin.y;
            CGFloat h = view.frame.size.height;
            if (y + h > scrollViewHeight) {
                scrollViewHeight = h + y;
            }
        }
    }
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, scrollViewHeight+10))];
}

- (void)fillBlocoInfoInBackground
{
    self.checkInButton.enabled = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query whereKey:@"bloco" equalTo:self.bloco];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parades = objects;
            if (self.parades.count) {
                self.checkInButton.enabled = YES;
            }
        }
    }];
}

- (IBAction)checkInButtonTapped:(UIButton *)sender
{    
    if (self.parades.count == 0)
        return;
    
    if (self.parades.count == 1) {
        [self confirmPresenceInParade:self.parades[0]];
        return;
    }
    
    UIActionSheet *confirmationSheet = [[UIActionSheet alloc] initWithTitle:@"Vai pular em qual dia?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (PFObject *parade in self.parades) {
        [confirmationSheet addButtonWithTitle:[parade[@"date"] description]];
    }
    
    confirmationSheet.cancelButtonIndex = self.parades.count;
    [confirmationSheet addButtonWithTitle:@"Nenhum"];
    
    confirmationSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [confirmationSheet showInView:self.view];
}

- (void)confirmPresenceInParade:(PFObject *)parade
{
    PFUser *me = [PFUser currentUser];

    PFQuery *queryMyPresence = [[PFQuery alloc] initWithClassName:@"Presence"];
    [queryMyPresence whereKey:@"user" equalTo:me];
    [queryMyPresence whereKey:@"parade" equalTo:parade];
    [queryMyPresence findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count == 0) {
            PFObject *presence = [[PFObject alloc] initWithClassName:@"Presence"];
            [presence setObject:me forKey:@"user"];
            [presence setObject:parade forKey:@"parade"];
            [presence saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error && succeeded) {
                    NSLog(@"Confirmed!");
                    [SVProgressHUD showSuccessWithStatus:@"Ah muleque!"];
                } else {
                    NSLog(@"Error when confirming presence.");
                }
            }];
        }
    }];
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= self.parades.count) // cancelling...
        return;
    
    NSLog(@"Confirming presence...");
    [self confirmPresenceInParade:self.parades[buttonIndex]];
}


#pragma mark -

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self sizeScrollViewToFit];
}

@end
