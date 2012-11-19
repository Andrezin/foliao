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

@interface MenuViewController ()
@property (strong, nonatomic) NSArray *menuItems;
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
        }/*,
        @{
            @"section_title": @"Que vai?",
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
        }*/,
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
    ZUUIRevealController *revealController = [self.parentViewController isKindOfClass:[ZUUIRevealController class]] ? (ZUUIRevealController *)self.parentViewController : nil;
    
    if (indexPath.section == 0 && indexPath.row == 0) {

		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByLocationViewController class]]) {
			BlocosByLocationViewController *blocosByPlaceViewController = [[BlocosByLocationViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByPlaceViewController];
			[revealController setFrontViewController:navigationController animated:NO];
			
		} else {
            [revealController revealToggle:self];
        }
        
	} else if (indexPath.section == 0 && indexPath.row == 1) {

		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByNameViewController class]]) {
			BlocosByNameViewController *blocosByNameViewController = [[BlocosByNameViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByNameViewController];
			[revealController setFrontViewController:navigationController animated:NO];
			
		} else {
            [revealController revealToggle:self];
        }
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlocosByDateViewController class]]) {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"];
			BlocosByDateViewController *blocosByDateViewController = [[BlocosByDateViewController alloc] initWithLocale:locale];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blocosByDateViewController];
			[revealController setFrontViewController:navigationController animated:NO];
			
		} else {
            [revealController revealToggle:self];
        }
    
    } else if (indexPath.section == 1) {
        [[PFFacebookUtils session] closeAndClearTokenInformation];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate sessionStateChanged:nil];
    }
}

@end
