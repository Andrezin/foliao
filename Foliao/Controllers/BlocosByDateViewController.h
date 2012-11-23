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
#import "KalBlocosDataSource.h"

#import "BaseViewController.h"

@class KalLogic, KalDate;

@interface BlocosByDateViewController : BaseViewController <UITableViewDelegate, KalViewDelegate, KalDataSourceCallbacks>
{
    KalBlocosDataSource *dataSource;
    KalLogic *logic;
    UITableView *tableView;
}

@property (nonatomic, retain, readonly) NSDate *selectedDate;

- (id)initWithSelectedDate:(NSDate *)date locale:(NSLocale *)locale;
- (id)initWithLocale:(NSLocale *)locale;

- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;

@end
