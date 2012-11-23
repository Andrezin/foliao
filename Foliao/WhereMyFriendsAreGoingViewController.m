//
//  WhereMyFriendsAreGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/23/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "WhereMyFriendsAreGoingViewController.h"
#import "ProfileViewController.h"
#import "FoliaoCell.h"
#import "AppConstants.h"

@interface WhereMyFriendsAreGoingViewController()

@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation WhereMyFriendsAreGoingViewController

- (void)viewDidLoad
{
    PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
            
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.friends = objects;
                [self.tableView reloadData];
            }];
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
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoliaoCell";
    FoliaoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UINib *foliaoNib = [UINib nibWithNibName:@"FoliaoCell" bundle:[NSBundle mainBundle]];
        NSArray *viewsFound = [foliaoNib instantiateWithOwner:self options:nil];
        cell = (FoliaoCell *)viewsFound[0];
    }
    
    cell.foliao = self.friends[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTABLE_VIEW_CELL_WITH_IMAGE_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = self.friends[indexPath.row];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
