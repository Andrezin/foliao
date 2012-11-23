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
    
    self.menuItems = @[
        @{
            @"section_title": @"Blocos",
            @"row_title": @[
                @"Por localização",
                @"Por nome",
                @"Por data"
            ]
        },
        @{
            @"section_title": @"Quem vai?",
            @"row_title": @[
                @"Onde eu vou",
                @"Onde meus amigos vão"
            ]
        },
        @{
            @"section_title": @"Onde tem mais?",
            @"row_title": @[
                @"Gente",
                @"Mulher",
                @"Homem"
            ]
        },
        @{
            @"section_title": @"Configurações",
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.menuItems[section][@"section_title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems[section][@"row_title"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.menuItems[indexPath.section][@"row_title"][indexPath.row];
    
    return cell;
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
    [[PFFacebookUtils session] closeAndClearTokenInformation];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate sessionStateChanged:nil];
}

@end
