//
//  BlocosByDateViewController.m
//  Foliao
//
//  Copyright (c) 2009 Keith Lazuka
//  License: http://www.opensource.org/licenses/mit-license.html
//


#import "BlocosByDateViewController.h"

#import "BlocoViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"


extern NSString *const KalDataSourceChangedNotification;

@interface BlocosByDateViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation BlocosByDateViewController

- (id)initWithSelectedDate:(NSDate *)date locale:(NSLocale *)locale
{
    if ((self = [super init])) {
        logic = [[KalLogic alloc] initForDate:date locale:locale];
        self.initialDate = date;
        self.selectedDate = date;
        
        dataSource = [[KalBlocosDataSource alloc] init];        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
    }
    return self;
}

- (id)initWithSelectedDate:(NSDate *)date
{
    return [self initWithSelectedDate:date locale:nil];
}

- (id)initWithLocale:(NSLocale *)locale
{
    return [self initWithSelectedDate:[NSDate date] locale:locale];
}

- (id)init
{
    return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)clearTable
{
    [dataSource removeAllItems];
    [tableView reloadData];
}

- (void)reloadData
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}


#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
    NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    [self clearTable];
    [dataSource loadItemsFromDate:from toDate:to];
    [tableView reloadData];
    [tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
}


#pragma mark Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.bloco = [dataSource paradeAtIndexPath:indexPath][@"bloco"];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}


#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [markedDates mutableCopy];
    for (int i=0; i<[dates count]; i++)
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    
    [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.calendarView.selectedDate];
}


#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
    [self reloadData];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}


#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    KalView *kalView = [[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic];
    self.view = kalView;
    tableView = kalView.tableView;
    tableView.dataSource = dataSource;
    tableView.delegate = self;
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tableView flashScrollIndicators];
}


@end

