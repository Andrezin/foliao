//
//  MenuViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "MenuViewController.h"
#import "ZUUIRevealController.h"

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
                @"Por localização"/*,
                @"Por nome",
                @"Por data"*/
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
        }*/
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
    [revealController revealToggle:self];
}

@end
