//
//  WhereAmIGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "WhereAmIGoingViewController.h"
#import "BlocoViewController.h"
#import "FoliaoRankingTitle.h"
#import "AppConstants.h"

@interface WhereAmIGoingViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelRanking;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *presences;

@end


@implementation WhereAmIGoingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *me = [PFUser currentUser];
    [self.imageViewProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", me[@"facebookId"]]] placeholderImage:[UIImage imageNamed:@"200x200.gif"]];
    self.imageViewProfile.clipsToBounds = YES;
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", me[@"firstName"], me[@"lastName"]];
    self.labelRanking.text = @"";
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Presence"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"parade.bloco"];
    [query orderByAscending:@"parade"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.presences = objects;
#warning Refactor: rename var name
        self.labelRanking.text = [NSString stringWithFormat:@"Confirmou %d bloco%@", self.presences.count, self.presences.count == 1 ? @"" : @"s"];
        
//        self.labelRanking.text = [FoliaoRankingTitle titleForBeingPresentIn:objects.count];
        [self.tableView reloadData];
    }];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seta-quem-vai"]];
    }
    
    cell.textLabel.text = self.presences[indexPath.row][@"parade"][@"bloco"][@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTABLE_VIEW_CELL_HEIGHT;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.bloco = self.presences[indexPath.row][@"parade"][@"bloco"];;
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

@end
