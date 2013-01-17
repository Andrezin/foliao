//
//  WhereAmIGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "ProfileViewController.h"
#import "ParadeViewController.h"
#import "AppConstants.h"
#import "DateUtil.h"
#import "UIColor+Foliao.h"
#import "SVProgressHUD.h"
#import "ThemeManager.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelNumberOfPresences;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *presences;

- (void)showNumberOfPresences;
- (void)customizeEditButton;
- (void)loadFoliaoPresences;

@end


@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeEditButton];
        
    if (!self.user || self.user == [PFUser currentUser]) {
        self.user = [PFUser currentUser];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.imageViewProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.user[@"facebookId"]]] placeholderImage:[UIImage imageNamed:@"fb_blank_profile_square"]];
    self.imageViewProfile.clipsToBounds = YES;
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstName"], self.user[@"lastName"]];
    self.labelNumberOfPresences.text = @"";
    
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFoliaoPresences];
}

- (void)customizeEditButton
{
    NSDictionary *attrs = @{
        UITextAttributeTextColor: [[ThemeManager currentTheme] color],
        UITextAttributeTextShadowColor: [UIColor clearColor],
    };
    [self.editButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [self.editButtonItem setTitle:@"Editar"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];

    
    NSDictionary *attrs;
    UIImage *buttonImage;
    if(editing == YES) {
        [self.editButtonItem setTitle:@"OK"];
        buttonImage = [[UIImage imageNamed:@"bt-roxo"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        attrs = @{
            UITextAttributeTextColor: [UIColor whiteColor],
            UITextAttributeTextShadowColor: [UIColor clearColor],
        };
        
    } else {
        [self.editButtonItem setTitle:@"Editar"];
        buttonImage = [[UIImage imageNamed:@"bt-branco"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        attrs = @{
            UITextAttributeTextColor: [[ThemeManager currentTheme] color],
            UITextAttributeTextShadowColor: [UIColor clearColor],
        };
    }
    
    [self.editButtonItem setBackgroundImage:buttonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.editButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
}

- (void)loadFoliaoPresences
{
    PFQuery *query = [PFQuery queryWithClassName:@"Presence"];
    [query whereKey:@"user" equalTo:self.user];
    [query includeKey:@"parade.bloco"];
    [query orderByAscending:@"parade"];
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 0.5 * 60 * 60; // half hour
    
    if (![query hasCachedResult])
        [SVProgressHUD showWithStatus:@"carregando..." maskType:SVProgressHUDMaskTypeNone];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.presences = [NSMutableArray arrayWithArray:objects];
        [self showNumberOfPresences];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void)showNumberOfPresences
{
    self.labelNumberOfPresences.text = [NSString stringWithFormat:@"Confirmou %d bloco%@", self.presences.count, self.presences.count == 1 ? @"" : @"s"];
}


#pragma mark UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BlocoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[[ThemeManager currentTheme] accessoryViewImage]];
    }
    
    cell.textLabel.text = self.presences[indexPath.row][@"parade"][@"bloco"][@"name"];
    cell.textLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    
    cell.detailTextLabel.text = [DateUtil stringFromDate:self.presences[indexPath.row][@"parade"][@"date"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTABLE_VIEW_CELL_HEIGHT;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParadeViewController *paradeViewController = [[ParadeViewController alloc] init];
    paradeViewController.parade = self.presences[indexPath.row][@"parade"];
    [self.navigationController pushViewController:paradeViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.user == [PFUser currentUser];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *presenceToRemove = self.presences[indexPath.row];
    [self.presences removeObject:presenceToRemove];
    [self showNumberOfPresences];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [presenceToRemove deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            PFObject *parade = presenceToRemove[@"parade"];
            
            if ([[PFUser currentUser][@"gender"] isEqualToString:@"male"])
                [parade incrementKey:@"malePresencesCount" byAmount:[NSNumber numberWithInt:-1]];
            if ([[PFUser currentUser][@"gender"] isEqualToString:@"female"])
                [parade incrementKey:@"femalePresencesCount" byAmount:[NSNumber numberWithInt:-1]];
            
            [parade incrementKey:@"totalPresencesCount" byAmount:[NSNumber numberWithInt:-1]];
            [parade saveInBackground];
            [PFQuery clearAllCachedResults];
        }
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"não vou";
}

@end
