//
//  RankingPeopleViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/23/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "WhereAreMoreViewController.h"
#import "ParadeViewController.h"
#import "SVProgressHUD.h"
#import "AppConstants.h"
#import "ThemeManager.h"

@interface WhereAreMoreViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *parades;

@end


@implementation WhereAreMoreViewController

- (void)viewDidLoad
{
    self.tableView.scrollsToTop = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query includeKey:@"bloco"];

    if (self.what == WhereAreMorePeople) {
        [query whereKey:@"totalPresencesCount" greaterThan:[NSNumber numberWithInt:0]];
        [query orderByDescending:@"totalPresencesCount"];
    } else if (self.what == WhereAreMoreWomen) {
        [query whereKey:@"femalePresencesCount" greaterThan:[NSNumber numberWithInt:0]];
        [query orderByDescending:@"femalePresencesCount"];
    } else if (self.what == WhereAreMoreMen) {
        [query whereKey:@"malePresencesCount" greaterThan:[NSNumber numberWithInt:0]];
        [query orderByDescending:@"malePresencesCount"];
    }
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 10 * 60; // ten minutes
    
    if (![query hasCachedResult])
        [SVProgressHUD showWithStatus:@"carregando..." maskType:SVProgressHUDMaskTypeNone];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.parades = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
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
        cell.accessoryView = [[UIImageView alloc] initWithImage:[[ThemeManager currentTheme] accessoryViewImage]];
    }
    
    cell.textLabel.text = self.parades[indexPath.row][@"bloco"][@"name"];
    
    NSString *count = @"";
    if (self.what == WhereAreMorePeople)
        count = [NSString stringWithFormat:@"%d pessoa%@",
               [self.parades[indexPath.row][@"totalPresencesCount"] integerValue],
               [self.parades[indexPath.row][@"totalPresencesCount"] integerValue] == 1 ? @"" : @"s"];
    
    if (self.what == WhereAreMoreWomen)
        count = [NSString stringWithFormat:@"%d mulher%@",
                 [self.parades[indexPath.row][@"femalePresencesCount"] integerValue],
                 [self.parades[indexPath.row][@"femalePresencesCount"] integerValue] == 1 ? @"" : @"es"];
    
    if (self.what == WhereAreMoreMen)
        count = [NSString stringWithFormat:@"%d home%@",
                 [self.parades[indexPath.row][@"malePresencesCount"] integerValue],
                 [self.parades[indexPath.row][@"malePresencesCount"] integerValue] == 1 ? @"m" : @"ns"];
    
    cell.detailTextLabel.text = count;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTABLE_VIEW_CELL_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParadeViewController *blocoViewController = [[ParadeViewController alloc] init];
    blocoViewController.parade = self.parades[indexPath.row];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

@end
