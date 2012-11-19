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

#define kALPHABET @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",\
                    @"J",@"K", @"L",@"M",@"N",@"O",@"P",@"Q",@"R",\
                    @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]


@interface BlocosByNameViewController() {
    NSMutableArray *_tableData;
}

@property (strong, nonatomic) NSArray *blocos;

- (void)arrangeTableData;

@end


@implementation BlocosByNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Bloco"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d blocos.", objects.count);
            self.blocos = objects;
            [self arrangeTableData];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)arrangeTableData
{
    _tableData = [NSMutableArray arrayWithCapacity:kALPHABET.count];
    
    // Takes only letters with at least one bloco
    NSMutableSet *lettersWithAtLeastOneBloco = [NSMutableSet set];
    for (PFObject *bloco in self.blocos) {
        NSString *firstLetter = [NSString stringWithFormat:@"%c", [bloco[@"name"] characterAtIndex:0]];
        [lettersWithAtLeastOneBloco addObject:firstLetter];
    }
    
    // For each letter, initialize its section
    for (NSString *letter in lettersWithAtLeastOneBloco) {
        [_tableData addObject:@{@"section":letter, @"rows":[NSMutableArray array]}];
    }
    
    // Fill table data
    for (PFObject *bloco in self.blocos) {
        NSString *firstLetter = [NSString stringWithFormat:@"%c", [bloco[@"name"] characterAtIndex:0]];
        for (NSDictionary *_sectionData in _tableData) {
            if ([firstLetter isEqualToString:_sectionData[@"section"]]) {
                [_sectionData[@"rows"] addObject:bloco];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _tableData[section][@"section"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return kALPHABET;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int i = 0; i < _tableData.count; i++) {
        if ([title isEqualToString:_tableData[i][@"section"]]) {
            return i;
        }
    }
    
    return -1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData[section][@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _tableData[indexPath.section][@"rows"][indexPath.row][@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.bloco = _tableData[indexPath.section][@"rows"][indexPath.row];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

@end
