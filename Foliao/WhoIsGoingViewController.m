//
//  WhoIsGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/20/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "WhoIsGoingViewController.h"
#import "FoliaoCell.h"
#import "AppConstants.h"

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
