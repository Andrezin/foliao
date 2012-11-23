//
//  RankingPeopleViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/23/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "RankingPeopleViewController.h"
#import "BlocoViewController.h"

@interface RankingPeopleViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *parades;

@end


@implementation RankingPeopleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query includeKey:@"bloco"];
    [query orderByDescending:@"presencesCount"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parades = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parades.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RankingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seta-quem-vai"]];
    }
    
    cell.textLabel.text = self.parades[indexPath.row][@"bloco"][@"name"];
    
    NSString *count = [NSString stringWithFormat:@"%d pessoa%@",
                       [self.parades[indexPath.row][@"presencesCount"] integerValue],
                       [self.parades[indexPath.row][@"presencesCount"] integerValue] == 1 ? @"" : @"s"];
    cell.detailTextLabel.text = count;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.parade = self.parades[indexPath.row];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

@end
