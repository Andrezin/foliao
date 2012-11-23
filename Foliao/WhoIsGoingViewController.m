//
//  WhoIsGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/20/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "WhoIsGoingViewController.h"
#import "ProfileViewController.h"
#import "FoliaoCell.h"
#import "AppConstants.h"

@interface WhoIsGoingViewController()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation WhoIsGoingViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // TODO: separate by parade date
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.folioes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCell";
    FoliaoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UINib *foliaoNib = [UINib nibWithNibName:@"FoliaoCell" bundle:[NSBundle mainBundle]];
        NSArray *viewsFound = [foliaoNib instantiateWithOwner:self options:nil];
        cell = (FoliaoCell *)viewsFound[0];
    }
    
    cell.foliao = self.folioes[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTABLE_VIEW_CELL_WITH_IMAGE_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = self.folioes[indexPath.row];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
