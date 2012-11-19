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

- (void)fetchParades;
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
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return paradesInSelectedDay.count;
}

#pragma mark Fetch from Parse

- (void)fetchParades
{
    dataIsReady = NO;
    [allParades removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query includeKey:@"bloco"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [allParades addObjectsFromArray:objects];
            dataIsReady = YES;
            [callback loadedDataSource:self];
        } else {
            NSLog(@"Error when fetching blocos by date");
        }
    }];
}


#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    /*
     * In this example, I load the entire dataset in one HTTP request, so the date range that is
     * being presented is irrelevant. So all I need to do is make sure that the data is loaded
     * the first time and that I always issue the callback to complete the asynchronous request
     * (even in the trivial case where we are responding synchronously).
     */
    
    if (dataIsReady) {
        [callback loadedDataSource:self];
        return;
    }
    
    callback = delegate;
    [self fetchParades];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    if (!dataIsReady)
        return [NSArray array];
    
    return [[self paradesFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    if (!dataIsReady)
        return;
    
    [paradesInSelectedDay addObjectsFromArray:[self paradesFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    [paradesInSelectedDay removeAllObjects];
}

#pragma mark -

- (NSArray *)paradesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (PFObject *parade in allParades)
        if (IsDateBetweenInclusive(parade[@"date"], fromDate, toDate))
            [matches addObject:parade];
    
    return matches;
}


@end
