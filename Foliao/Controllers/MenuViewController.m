//
//  MenuViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "MenuViewController.h"

#import "AppDelegate.h"
#import "ZUUIRevealController.h"
#import "BlocosByLocationViewController.h"
#import "BlocosByNameViewController.h"
#import "BlocosByDateViewController.h"

#import "ProfileViewController.h"
#import "WhereMyFriendsAreGoingViewController.h"

#import "WhereAreMoreViewController.h"


@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menuItems;

- (void)showBlocosByLocation;
- (void)showBlocosByName;
- (void)showBlocosByDate;

- (void)showWhereAmIGoing;
- (void)showWhereMyFriendsAreGoing;

- (void)showPeopleRanking;
- (void)showWomanRanking;
- (void)showManRanking;

- (void)logout;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.menuItems = @[
        @{
            @"section_title": [@"Buscar por" uppercaseString],
            @"row_title": @[
                @"Localização",
                @"Nome",
                @"Data"
            ]
        },
        @{
            @"section_title": [@"Programação" uppercaseString],
            @"row_title": @[
                @"Blocos que eu vou",
                @"Onde meus amigos vão"
            ]
        },
        @{
            @"section_title": [@"Bombando de" uppercaseString],
            @"row_title": @[
                @"Gente",
                @"Mulher",
                @"Homem"
            ]
        },
        @{
            @"section_title": [@"Configurações" uppercaseString],
            @"row_title": @[
                @"Logout"
            ]
        }
    ];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    [sectionView setImage:[UIImage imageNamed:@"menu-section-background"]];
    
    UILabel *labelSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-10, 15)];
    labelSectionTitle.backgroundColor = [UIColor clearColor];
    labelSectionTitle.text = self.menuItems[section][@"section_title"];
    labelSectionTitle.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    labelSectionTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    labelSectionTitle.shadowOffset = CGSizeMake(0, 1);
    labelSectionTitle.shadowColor = [UIColor blackColor];
    
    [sectionView addSubview:labelSectionTitle];
    
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems[section][@"row_title"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MenuCell";
    
    if (indexPath.row+1 != [tableView numberOfRowsInSection:indexPath.section]) {
        CellIdentifier = @"MenuSectionLastCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seta-branca"]];
        
        UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        [topBorder setBackgroundColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1]];
        [cell addSubview:topBorder];
        
        if (indexPath.row+1 != [tableView numberOfRowsInSection:indexPath.section]) {
            UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, tableView.frame.size.width, 1)];
            [bottomBorder setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]];
            [cell addSubview:bottomBorder];
        }
    }
    
    cell.textLabel.text = self.menuItems[indexPath.section][@"row_title"][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self showBlocosByLocation]; break;
                case 1:
                    [self showBlocosByName]; break;
                case 2:
                    [self showBlocosByDate]; break;
            } break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showWhereAmIGoing]; break;
                case 1:
                    [self showWhereMyFriendsAreGoing]; break;
            } break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self showPeopleRanking]; break;
                case 1:
                    [self showWomanRanking]; break;
                case 2:
                    [self showManRanking]; break;
            } break;
        case 3:
            [self logout]; break;
    }
}

- (void)showBlocosByLocation
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByLocationViewController class]]) {
        BlocosByLocationViewController *blocosByPlaceViewController = [[BlocosByLocationViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByPlaceViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showBlocosByName
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByNameViewController class]]) {
        BlocosByNameViewController *blocosByNameViewController = [[BlocosByNameViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByNameViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showBlocosByDate
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByDateViewController class]]) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"];
        BlocosByDateViewController *blocosByDateViewController = [[BlocosByDateViewController alloc] initWithLocale:locale];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByDateViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showWhereAmIGoing
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[ProfileViewController class]]) {
        
        ProfileViewController *whereAmIGoingViewController = [[ProfileViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:whereAmIGoingViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showWhereMyFriendsAreGoing
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[WhereMyFriendsAreGoingViewController class]]) {
        
        WhereMyFriendsAreGoingViewController *whereMyFriendsAreGoingViewController = [[WhereMyFriendsAreGoingViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:whereMyFriendsAreGoingViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showPeopleRanking
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    if (![topViewController isKindOfClass:[WhereAreMoreViewController class]] ||
        ([topViewController isKindOfClass:[WhereAreMoreViewController class]] &&
         [(WhereAreMoreViewController *)topViewController what] != WhereAreMorePeople)) {
        
        WhereAreMoreViewController *whereAreMoreVC = [[WhereAreMoreViewController alloc] init];
        whereAreMoreVC.what = WhereAreMorePeople;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:whereAreMoreVC];
        [revealController setFrontViewController:navigationController animated:NO];
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showWomanRanking
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    if (![topViewController isKindOfClass:[WhereAreMoreViewController class]] ||
        ([topViewController isKindOfClass:[WhereAreMoreViewController class]] &&
         [(WhereAreMoreViewController *)topViewController what] != WhereAreMoreWomen)) {
        
        WhereAreMoreViewController *whereAreMoreVC = [[WhereAreMoreViewController alloc] init];
        whereAreMoreVC.what = WhereAreMoreWomen;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:whereAreMoreVC];
        [revealController setFrontViewController:navigationController animated:NO];
    } else {
        [revealController revealToggle:self];
    }
}

- (void)showManRanking
{
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    if (![topViewController isKindOfClass:[WhereAreMoreViewController class]] ||
        ([topViewController isKindOfClass:[WhereAreMoreViewController class]] &&
         [(WhereAreMoreViewController *)topViewController what] != WhereAreMoreMen)) {
        
        WhereAreMoreViewController *whereAreMoreVC = [[WhereAreMoreViewController alloc] init];
        whereAreMoreVC.what = WhereAreMoreMen;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:whereAreMoreVC];
        [revealController setFrontViewController:navigationController animated:NO];
    } else {
        [revealController revealToggle:self];
    }
}

- (void)logout
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate logOut];
}

@end
