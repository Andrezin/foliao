//
//  BlocosByDateViewController.h
//  Foliao
//
//  Copyright (c) 2009 Keith Lazuka
//  License: http://www.opensource.org/licenses/mit-license.html
//


#import <UIKit/UIKit.h>
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol

#import "NavigationRootLevelViewController.h"

@class KalLogic, KalDate;

@interface BlocosByDateViewController : NavigationRootLevelViewController <KalViewDelegate, KalDataSourceCallbacks>
{
    KalLogic *logic;
    UITableView *tableView;
}

@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, retain, readonly) NSDate *selectedDate;

- (id)initWithSelectedDate:(NSDate *)selectedDate;  // designated initializer. When the calendar is first displayed to the user, the month that contains 'selectedDate' will be shown and the corresponding tile for 'selectedDate' will be automatically selected.
- (void)reloadData;                                 // If you change the KalDataSource after the KalViewController has already been displayed to the user, you must call this method in order for the view to reflect the new data.
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.

@end
