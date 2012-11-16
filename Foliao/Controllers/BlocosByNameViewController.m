//
//  BlocosByNameViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BlocosByNameViewController.h"
#import "BlocoViewController.h"


@interface BlocosByNameViewController()

@property (strong, nonatomic) NSArray *blocos;

@end


@implementation BlocosByNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFObject *desfileSargento = [[PFObject alloc] initWithClassName:@"Parade"];
//    [desfileSargento setObject:[PFObject objectWithoutDataWithClassName:@"Bloco" objectId:@"3Lu1AYt7Xo"] forKey:@"bloco"];
//    [desfileSargento setObject:[NSDate date] forKey:@"date"];
//    
//    PFGeoPoint *geopoint = [[PFGeoPoint alloc] init];
//    geopoint.latitude = -22.983819;
//    geopoint.longitude = -43.204528;
//    [desfileSargento setObject:geopoint forKey:@"location"];
//    [desfileSargento saveInBackground];

    PFQuery *query = [PFQuery queryWithClassName:@"Bloco"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d blocos.", objects.count);
            self.blocos = objects;
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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
    return self.blocos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.blocos[indexPath.row][@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.bloco = self.blocos[indexPath.row];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

@end
