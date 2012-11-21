//
//  WhoIsGoingViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/20/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "WhoIsGoingViewController.h"


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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSURL *profileImageURL = [NSURL URLWithString:[
                                    NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",
                                                   self.folioes[indexPath.row][@"facebookId"]]];
    
    cell.imageView.frame = CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height);
    [cell.imageView setImageWithURL:profileImageURL placeholderImage:[UIImage imageNamed:@"100x100.gif"]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           self.folioes[indexPath.row][@"firstName"],
                           self.folioes[indexPath.row][@"lastName"]];
    
    return cell;
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
