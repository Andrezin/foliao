//
//  KalBlocosDataSource.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "KalBlocosDataSource.h"


static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}


@interface KalBlocosDataSource()

@property (nonatomic, readonly) BOOL dataIsReady;

- (void)fetchParadesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)paradesFrom:(NSDate *)fromDate to:(NSDate *)toDate;

@end


@implementation KalBlocosDataSource

- (id)init
{
    if (self = [super init]) {
        allParades = [[NSMutableArray alloc] init];
        paradesInSelectedDay = [[NSMutableArray alloc] init];
    }
    return self;
}

- (PFObject *)paradeAtIndexPath:(NSIndexPath *)indexPath
{
    return paradesInSelectedDay[indexPath.row];
}

#pragma mark Table View data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BlocoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    PFObject *parade = [self paradeAtIndexPath:indexPath];
    cell.textLabel.text = parade[@"bloco"][@"name"];
    cell.textLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return paradesInSelectedDay.count;
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    callback = delegate;
    [self fetchParadesFrom:fromDate to:toDate];
    [callback loadedDataSource:self];
}

- (void)fetchParadesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    [allParades removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query whereKey:@"date" greaterThanOrEqualTo:fromDate];
    [query whereKey:@"date" lessThanOrEqualTo:toDate];
    [query includeKey:@"bloco"];
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 0.5 * 60 * 60; // half hour
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [allParades addObjectsFromArray:objects];
            [callback loadedDataSource:self];
        } else {
            NSLog(@"Error when fetching blocos by date");
        }
    }];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    if (!self.dataIsReady)
        return [NSArray array];
    
    return [[self paradesFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    if (!self.dataIsReady)
        return;
    
    [paradesInSelectedDay addObjectsFromArray:[self paradesFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    [paradesInSelectedDay removeAllObjects];
}

#pragma mark -

- (BOOL)dataIsReady
{
    return allParades.count > 0;
}

- (NSArray *)paradesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (PFObject *parade in allParades)
        if (IsDateBetweenInclusive(parade[@"date"], fromDate, toDate))
            [matches addObject:parade];
    
    return matches;
}


@end
