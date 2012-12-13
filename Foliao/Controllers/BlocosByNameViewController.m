//
//  BlocosByNameViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BlocosByNameViewController.h"
#import "ParadeViewController.h"
#import "AppConstants.h"
#import "DateUtil.h"

#define kALPHABET @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",\
                    @"J",@"K", @"L",@"M",@"N",@"O",@"P",@"Q",@"R",\
                    @"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]


@interface BlocosByNameViewController() {
    NSMutableArray *_tableData;
}

@property (strong, nonatomic) NSArray *parades;

- (void)arrangeTableData;

@end


@implementation BlocosByNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel = @"Lista de blocos";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query whereKey:@"date" greaterThanOrEqualTo:[DateUtil todaysMidnight]];
    [query includeKey:@"bloco"];
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 0.5 * 60 * 60; // half hour
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d blocos.", objects.count);
            self.parades = objects;
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
    for (PFObject *parade in self.parades) {
        NSString *firstLetter = [NSString stringWithFormat:@"%c", [parade[@"bloco"][@"name"] characterAtIndex:0]];
        [lettersWithAtLeastOneBloco addObject:firstLetter];
    }
    
    // For each letter, initialize its section
    for (NSString *letter in lettersWithAtLeastOneBloco) {
        [_tableData addObject:@{@"section":letter, @"rows":[NSMutableArray array]}];
    }
    
    // Fill table data
    for (PFObject *parade in self.parades) {
        NSString *firstLetter = [NSString stringWithFormat:@"%c", [parade[@"bloco"][@"name"] characterAtIndex:0]];
        for (NSDictionary *_sectionData in _tableData) {
            if ([firstLetter isEqualToString:_sectionData[@"section"]]) {
                [_sectionData[@"rows"] addObject:parade];
            }
        }
    }
    
    // Sort table data
    [_tableData sortUsingComparator:^NSComparisonResult(NSDictionary *section1, NSDictionary *section2) {
        NSString *sectionLetter1 = section1[@"section"];
        NSString *sectionLetter2 = section2[@"section"];
        
        return [sectionLetter1 compare:sectionLetter2];
    }];
    
    for (NSDictionary *_sectionData in _tableData) {
        [(NSMutableArray *)_sectionData[@"rows"] sortUsingComparator:^NSComparisonResult(PFObject *parade1, PFObject *parade2) {
            NSString *blocoName1 = parade1[@"bloco"][@"name"];
            NSString *blocoName2 = parade2[@"bloco"][@"name"];

            return [blocoName1 compare:blocoName2];
        }];
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
    static NSString *CellIdentifier = @"BlocoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessibilityLabel = @"Nome do bloco";
    }
    
    PFObject *parade = _tableData[indexPath.section][@"rows"][indexPath.row];
    cell.textLabel.text = parade[@"bloco"][@"name"];
    cell.detailTextLabel.text = [DateUtil stringFromDate:parade[@"date"]];
    cell.textLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    
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
    
    ParadeViewController *paradeViewController = [[ParadeViewController alloc] init];
    paradeViewController.parade = _tableData[indexPath.section][@"rows"][indexPath.row];
    [self.navigationController pushViewController:paradeViewController animated:YES];
}

@end
